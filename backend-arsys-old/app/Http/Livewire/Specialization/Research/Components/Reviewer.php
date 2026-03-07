<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Http\Livewire\Arsys\Specialization\Research\Components\TelegramId;
use App\Http\Livewire\Arsys\Specialization\Research\Components\Throwable;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\ResearchMilestoneLog;
use App\Models\ArSys\ResearchRemark;
use App\Models\ArSys\ResearchReview;
use App\Models\ArSys\ResearchType;
use App\Models\ArSys\Staff;
use App\Models\User;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Telegram\Bot\Laravel\Facades\Telegram;

class Reviewer extends Component
{
    use LivewireAlert;
    public $researchId;
    public $listeners = ['refresh_ArSysSpecializationResearchNewReviewer' => '$refresh',
                        ];
    public $staffs;

    public function render()
    {
        $this->staffs = Staff::all();
        $research = Research::find($this->researchId);

        return view('livewire.specialization.research.components.reviewer', ['research' => $research]);
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function proceedToReview(){
        if (ResearchReview::where('research_id', $this->researchId)->count() != 0){
            //Research::find($research_id)->increment('research_milestone');
            $research = Research::where('id', $this->researchId)->first();

            if($research->submit){
                ResearchLog::where('research_id', $this->researchId)
                    ->where('type_id', ResearchLogType::where('code', 'SUB')->first()->id)
                    ->where('status', 1)
                    ->update([
                        'status' => null,
                ]);
                ResearchLog::create([
                    'research_id' => $this->researchId,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','REV')->first()->id,
                    'message' => ResearchLogType::where('code','REV')->first()->description,
                    'status' => 1,
                ]);
                $researchMilestoneLog = ResearchMilestoneLog::where('research_id', $this->researchId)->where('research_model_id',ResearchType::where('program_id', Auth::user()->staff->program_id)->where('id', $research->type_id)->first()->research_model_id)
                ->latest()->first();
                $milestoneSequence = ResearchMilestone::where('id', $research->milestone_id)->first()->sequence + 1;
                ResearchMilestoneLog::create([
                    'research_id' => $this->researchId,
                    'research_model_id' => ResearchType::where('program_id', Auth::user()->staff->program_id)
                                        ->where('id', $research->type_id)->first()->data->research_model_id,
                    'milestone_id' => ResearchMilestone::where('research_model_id', ResearchType::where('program_id', Auth::user()->staff->program_id)
                                        ->where('id', $research->type_id)->first()->data->research_model_id)
                                        ->where('sequence', $milestoneSequence)->first()->id,
                ]);
                Research::find($this->researchId)->increment('milestone_id');
                ResearchRemark::create([
                    'discussant_id' => Auth::user()->id,
                    'research_id' => $this->researchId,
                    'message' => '<p style="margin:0">Your research topic is in review process;
                    please contact and ask the assigned reviewer to follow up the review process!.</p>',
                ]);

                /**
                 * Send Telegram notification to student
                 */
                /*$research = Research::where('id', $this->researchId)->first();
                if(!is_null($research->student->user->telegram)){
                    if($research->student->user->telegram->telegram_blocked != 1){
                        try
                        {
                            Telegram::sendMessage([
                                //'chat_id' => '764858393',
                                'chat_id' => $research->student->user->telegram->telegram_chat_id,
                                'text' => User::where('id', Auth::user()->id)->first()->staff->code.': Your research topic is in review process, please contact and ask the assigned reviewer to follow up the review process!.',
                            ]);

                        }
                        catch (\Exception $e)
                        {
                            Telegram::sendMessage([
                                'chat_id' => '764858393',
                                'text'    => 'There is error in the code for '. $research->student->first_name,
                            ]);
                            TelegramId::where('user_id', $research->student->user->id)->update([
                                'telegram_blocked' => 1,
                            ]);
                        }
                        catch (Throwable $e)
                        {
                            Telegram::sendMessage([
                                'chat_id' => '764858393',
                                'text'    => 'Some one block the ArSysNG: '. $research->student->first_name,
                            ]);
                            TelegramId::where('user_id', $research->student->user->id)->update([
                                'telegram_blocked' => 1,
                            ]);
                        }
                    }

                }
                */
                /**
                 * Send Telegram notification to reviewer
                 */
                /*foreach($research->reviewer as $reviewer){
                    if(!is_null($reviewer->staff->user->telegram)){
                        if($reviewer->staff->user->telegram->telegram_blocked != 1){
                            try
                            {
                                Telegram::sendMessage([
                                    //'chat_id' => '764858393',
                                    'chat_id' => $reviewer->staff->user->telegram->telegram_chat_id,
                                    'text' => User::where('id', Auth::user()->id)->first()->staff->code.': You have been appointed as a reviewer of '.$research->student->first_name.' ('.$research->student->number.', '.$research->student->program->abbrev .') entitled '.strtoupper($research->title),
                                ]);

                            }
                            catch (\Exception $e)
                            {
                                Telegram::sendMessage([
                                    'chat_id' => '764858393',
                                    'text'    => 'There is error in the code for '. $research->student->first_name,
                                ]);
                                TelegramId::where('user_id', $research->student->user->id)->update([
                                    'telegram_blocked' => 1,
                                ]);
                            }
                            catch (Throwable $e)
                            {
                                Telegram::sendMessage([
                                    'chat_id' => '764858393',
                                    'text'    => 'Some one block the ArSysNG: '. $research->student->first_name,
                                ]);
                                TelegramId::where('user_id', $research->student->user->id)->update([
                                    'telegram_blocked' => 1,
                                ]);
                            }
                        }

                    }
                }
                */

                $this->emit('closeView_ArSysSpecializationResearchPage');
                $this->emit('refresh_ArSysSpecializationResearchPage');
            }
        }else{
            $this->alert('warning', 'At least one reviewer should be assigned');
        }
    }
    public function reject($researchId){
        $research = Research::find($researchId);
        Research::find($researchId)->update([
            'milestone_id' => ResearchMilestone::where('code', 'Rejected')->first()->id,
        ]);

        if($research->review){
            ResearchLog::where('research_id', $this->researchId)
            ->where('type_id', ResearchLogType::where('code', 'REV')->first()->id)
            ->where('status', 1)
            ->update([
                    'status' => null,
            ]);
        }

        if($research->submit){
            ResearchLog::where('research_id', $this->researchId)
            ->where('type_id', ResearchLogType::where('code', 'SUB')->first()->id)
            ->where('status', 1)
            ->update([
                    'status' => null,
            ]);
        }

        ResearchLog::create([
            'research_id' => $this->researchId,
            'loger_id' => Auth::user()->id,
            'type_id' => ResearchLogType::where('code','RJC')->first()->id,
            'message' => ResearchLogType::where('code','RJC')->first()->description,
            'status' => 1,
        ]);

        $researchMilestoneLog = ResearchMilestoneLog::where('research_id', $this->researchId)
                                ->where('research_model_id',ResearchType::where('id', Research::find($this->researchId)->type_id)->first()->research_model_id)
                                ->latest()->first();
        /**
         * Create milestone logs
         */
        ResearchMilestoneLog::create([
            'research_id' => $this->researchId,
            'research_model_id' => ResearchType::where('program_id', Auth::user()->staff->program_id)
                                    ->where('id', Research::find($this->researchId)->type_id)->first()->data->research_model_id,
            'milestone_id' => null,
        ]);
        $this->emit('closeView_ArSysSpecializationResearchPage');
        $this->emit('refresh_ArSysSpecializationResearchPage');
    }
}
