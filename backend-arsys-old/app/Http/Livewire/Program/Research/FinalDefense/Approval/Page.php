<?php

namespace App\Http\Livewire\Program\Research\FinalDefense\Approval;

use App\Models\ArSys\DefenseApproval;
use App\Models\ArSys\DefenseRole;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchMilestone;
use Auth;
use Carbon\Carbon;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $pageName = 'researchPage';
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        $approvals = DefenseApproval::where('approver_id', Auth::user()->staff->id)
            ->where('approver_role', DefenseRole::where('code', 'PRG')->first()->id)
            ->orderBy('decision', 'ASC')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'finalDefenseApprovalPage');

        return view('livewire.program.research.final-defense.approval.page',
            [
                'approvals' => $approvals,
            ]);
    }

    public function approve($approvalId){
        DefenseApproval::find($approvalId)->update([
            'decision' => 1,
            'approval_date' => Carbon::now(),
        ]);

        $researchId = DefenseApproval::find($approvalId)->research->id;
        if(Research::find($researchId)->finaldefenseApproval->count() == Research::find($researchId)->finaldefenseApproved->count()){
                Research::find($researchId)->update([
                    'milestone_id' => ResearchMilestone::where('code', 'Final-defense')->where('phase', 'Approved')->first()->id,
                ]);
            }else{
                Research::find($researchId)->update([
                    'milestone_id' => ResearchMilestone::where('code', 'Final-defense')->where('phase', 'Submitted')->first()->id,
                ]);
            }
    }
}
