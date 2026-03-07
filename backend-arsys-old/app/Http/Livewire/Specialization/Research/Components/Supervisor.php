<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Http\Livewire\Arsys\Specialization\Research\Components\TelegramId;
use App\Http\Livewire\Arsys\Specialization\Research\Components\Throwable;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\ResearchMilestoneLog;
use App\Models\ArSys\ResearchReview;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\ResearchSupervisorDummy;
use App\Models\ArSys\ResearchSupervisorExternal;
use App\Models\ArSys\ResearchSupervisorExternalDummy;
use App\Models\ArSys\ResearchSupervisorExtra;
use App\Models\ArSys\ResearchType;
use App\Models\ArSys\Staff;
use App\Models\User;
use Auth;
use Carbon\Carbon;
use Livewire\Component;
use Telegram\Bot\Laravel\Facades\Telegram;

class Supervisor extends Component
{
    public $listeners = ['refresh_ArSysSpecializationResearchNewSupervisor' => '$refresh'];

    public $researchId;
    public $research;
    public $proceedToApprove = 0;
    public $researchCounter = 0;
    public function render()
    {
        if($this->researchId){
            $this->research = Research::where('id', $this->researchId)->first();

            if((ResearchSupervisorDummy::where('research_id', $this->researchId)->get()->count()
                ==  Research::where('id', $this->researchId)->first()->type->supervisor_number)
                ||
                (ResearchSupervisorDummy::where('research_id', $this->researchId)->get()->count()
                +
                ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->get()->count()
                ==
                Research::where('id', $this->researchId)->first()->type->supervisor_number+1
                &&
                Research::where('id', $this->researchId)->first()->supervisorExtra->status ==1))

            {
                $this->proceedToApprove = 1;
            }else{
                $this->proceedToApprove = 0;
            }
            $this->researchCounter = ResearchSupervisorDummy::where('research_id', $this->researchId)->get()->count()+
            ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->get()->count();
        }

        return view('livewire.specialization.research.components.supervisor');
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function proceedToApprove(){
        $research = Research::find($this->researchId);

        //if ( ResearchSupervisorDummy::where('research_id', $this->researchId)->count() +
            //ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->count()
            //=== $research->type->supervisor_number){
        if($this->proceedToApprove == 1){
                $supervisors = ResearchSupervisorDummy::where('research_id', $this->researchId)->get();
                foreach($supervisors as $index => $supervisor){
                    ResearchSupervisor::updateOrCreate([
                        'research_id' => $this->researchId,
                        'supervisor_id' => $supervisor->supervisor_id,
                        'order' => $index+1,
                    ]);
                    ResearchSupervisorDummy::where('id', $supervisor->id)->delete();
                }
                if($research->review){
                    ResearchLog::where('research_id', $this->researchId)
                        ->where('type_id', ResearchLogType::where('code', 'REV')->first()->id)
                        ->update([
                            'status' => null,
                    ]);
                    Research::find($this->researchId)->increment('milestone_id');
                }else{
                    ResearchLog::where('research_id', $this->researchId)
                        ->where('type_id', ResearchLogType::where('code', 'SUB')->first()->id)
                        ->update([
                            'status' => null,
                    ]);
                    Research::find($this->researchId)->increment('milestone_id');
                    Research::find($this->researchId)->increment('milestone_id');
                }
                ResearchLog::create([
                    'research_id' => $this->researchId,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','ACT')->first()->id,
                    'message' => ResearchLogType::where('code','ACT')->first()->description,
                    'status' => 1,
                ]);

                ResearchLog::create([
                    'research_id' => $this->researchId,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','SIASPRO')->first()->id,
                    'message' => ResearchLogType::where('code','SIASPRO')->first()->description,
                    'status' => 1,
                ]);

                /**
                 * Approval SIAS
                 */
                $research = Research::find($this->researchId);
                if($research->SIASPro->status == 1){
                    $research->SIASPro->update([
                        'status' => null,
                    ]);
                }else{
                    $research->SIASPro->update([
                        'status' => 1,
                    ]);
                }


                $researchMilestoneLog = ResearchMilestoneLog::where('research_id', $this->researchId)
                                        ->where('research_model_id',ResearchType::where('id', $research->type_id)->first()->research_model_id)
                                        ->latest()->first();
                                        $milestoneSequence = ResearchMilestone::where('id', $research->milestone_id)->first()->sequence + 1;
                /**
                 * Create milestone logs
                 */
                ResearchMilestoneLog::create([
                    'research_id' => $this->researchId,
                    'research_model_id' => ResearchType::where('program_id', Auth::user()->staff->program_id)
                                            ->where('id', $research->type_id)->first()->data->research_model_id,
                    'milestone_id' => Research::find($this->researchId)->milestone_id,
                ]);

                if($research->type->supervisor_number == 2){
                    if(ResearchSupervisorDummy::where('research_id', $this->researchId)->get()
                    ->contains('supervisor_id', Staff::where('code', 'EXT')->first()->id)){
                        $supervisorsExternal = ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->get();
                        foreach($supervisorsExternal as $supervisor){
                            ResearchSupervisorExternal::updateOrCreate([
                                'research_id' => $research_id,
                                'supervisor_name' => $supervisor->supervisor_name,
                                'institution' => $supervisor->institution,
                            ]);
                            ResearchSupervisorExternalDummy::where('id', $supervisorsExternal->id)->delete();
                        }
                    }
                }elseif($research->type->supervisor_number == 1){
                    $supervisorsExternal = ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->get();
                    foreach($supervisorsExternal as $supervisor){
                        ResearchSupervisorExternal::updateOrCreate([
                            'research_id' => $research_id,
                            'supervisor_name' => $supervisor->supervisor_name,
                            'institution' => $supervisor->institution,
                        ]);
                        ResearchSupervisorExternalDummy::where('id', $supervisorsExternal->id)->delete();
                    }
                }

                /**
                 * Update Review
                 */
                foreach(Research::find($this->researchId)->proposalReview as $review){
                    ResearchReview::find($review->id)->update([
                        'approval_date' => Carbon::now(),
                    ]);
                }
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
                                'text' => User::where('id', Auth::user()->id)->first()->staff->code.': Your research topic is accepted, please contact and ask the assigned supervisor to follow up the research processes!.',
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
                                    'text' => User::where('id', Auth::user()->id)->first()->staff->code.': You have been assigned as the supervisor of '.$research->student->first_name.' ('.$research->student->number.', '.$research->student->program->abbrev .') entitled '.strtoupper($research->title),
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
    }

    public function setSupervisorExtra($researchId){

        if(is_null(ResearchSupervisorExtra::where('research_id', $researchId)->first())){

            ResearchSupervisorExtra::create([
                'research_id' => $researchId,
                'status' => 1,
            ]);
        }else{
            if(ResearchSupervisorExtra::where('research_id', $researchId)->first()->status == 1){
                ResearchSupervisorExtra::where('research_id', $researchId)->update([
                    'research_id' => $researchId,
                    'status' => null,
                ]);
            }else{
                ResearchSupervisorExtra::where('research_id', $researchId)->update([
                    'research_id' => $researchId,
                    'status' => 1,
                ]);
            }

        }
    }

    public function refresh_ArSysSpecializationResearchNewSupervisor(){
        dd('here');
    }
}
