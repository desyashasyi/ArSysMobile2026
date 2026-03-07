<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Auth;
use Carbon\Carbon;
use App\Models\User;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchType;
use App\Models\ArSys\Program;
use App\Models\ArSys\Student;
use App\Models\ArSys\ResearchSupervise;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\DefenseApproval;
use App\Models\ArSys\DefenseExaminer;
use App\Models\ArSys\DefenseExaminerPresence;
use App\Models\ArSys\DefenseSupervisorPresence;
use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchSuperviseDiscussion; // New import

class StaffController extends Controller
{
    public function getSupervisedResearch(Request $request)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can access this resource.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }


        $query = Research::whereHas('supervisor', function($q) use ($staffId) {
            $q->where('supervisor_id', $staffId);
        })
        ->whereHas('active', function($q) {
            $q->where('status', 1);
        });

        if ($request->has('search')) {
            $searchTerm = $request->input('search');
            $query->where(function($q) use ($searchTerm) {
                $q->where('title', 'like', '%' . $searchTerm . '%')
                  ->orWhereHas('student', function($sq) use ($searchTerm) {
                      $sq->where('name', 'like', '%' . $searchTerm . '%')
                         ->orWhere('nim', 'like', '%' . $searchTerm . '%');
                  });
            });
        }

        if ($request->has('research_type_id')) {
            $query->where('research_type_id', $request->input('research_type_id'));
        }

        $query->orderBy('milestone_id', 'DESC');

        $perPage = $request->input('per_page', 10);
        $researchs = $query->paginate($perPage);

        $transformedResearch = $researchs->map(function($research) {
            return [
                'id' => $research->id,
                'student_id' => $research->student->id ?? null,
                'name' => $research->student->name ?? 'N/A',
                'nim' => $research->student->nim ?? 'N/A',
                'milestone_status' => $research->milestone->status_name ?? 'N/A',
                'research_title' => $research->title,
            ];
        });

        return response()->json([
            'data' => $transformedResearch,
            'current_page' => $researchs->currentPage(),
            'last_page' => $researchs->lastPage(),
            'per_page' => $researchs->perPage(),
            'total' => $researchs->total(),
        ]);
    }

    public function getResearchTypes(Request $request)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can access this resource.'
            ], 403);
        }

        $programId = $user->staff->program_id ?? null;

        if (is_null($programId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff program ID not found.'
            ], 403);
        }

        $program = Program::find($programId);
        $programLevelId = $program->level_id ?? null;

        if (is_null($programLevelId)) {
             return response()->json([
                'success' => false,
                'message' => 'Program level ID not found.'
            ], 403);
        }


        $researchTypes = ResearchType::where('program_id', $programId)
            ->whereHas('data', function($query) use ($programLevelId) {
                $query->where('level_id', $programLevelId);
            })
            ->get(['id', 'name']);

        return response()->json($researchTypes);
    }

    public function getResearchDetails($researchId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can access this resource.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $research = Research::where('id', $researchId)
            ->whereHas('supervisor', function($q) use ($staffId) {
                $q->where('supervisor_id', $staffId);
            })
            ->with(['student', 'milestone', 'researchType', 'supervisors.staff', 'examiners.staff'])
            ->first();

        if (!$research) {
            return response()->json([
                'success' => false,
                'message' => 'Research not found or you are not the supervisor.'
            ], 404);
        }

        $isSupervisor = $research->supervisors->contains('supervisor_id', $staffId);

        $participant = $research->defense->first();

        $responseData = $research->toArray();
        $responseData['is_supervisor'] = $isSupervisor;
        $responseData['participant_id'] = $participant ? $participant->id : null;


        return response()->json([
            'success' => true,
            'data' => $responseData
        ]);
    }

    public function getResearchSupervisionDetails($researchId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can access this resource.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $research = Research::where('id', $researchId)
            ->whereHas('supervisor', function($q) use ($staffId) {
                $q->where('supervisor_id', $staffId);
            })
            ->with([
                'student',
                'milestone',
                'researchType',
                'supervisors.staff',
                'supervises'
            ])
            ->first();

        if (!$research) {
            return response()->json([
                'success' => false,
                'message' => 'Research not found or you are not the supervisor.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $research
        ]);
    }

    public function toggleResearchSupervisorBypass(Request $request, $supervisorId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can perform this action.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $researchSupervisor = ResearchSupervisor::find($supervisorId);

        if (!$researchSupervisor) {
            return response()->json([
                'success' => false,
                'message' => 'Research Supervisor record not found.'
            ], 404);
        }

        if ($researchSupervisor->supervisor_id != $staffId) {
             return response()->json([
                'success' => false,
                'message' => 'You are not authorized to modify this supervisor record.'
            ], 403);
        }


        $researchSupervisor->bypass = !$researchSupervisor->bypass;
        $researchSupervisor->save();

        return response()->json([
            'success' => true,
            'message' => 'Supervisor bypass status toggled successfully.',
            'new_bypass_status' => $researchSupervisor->bypass
        ]);
    }

    public function toggleResearchSuperviseApproval(Request $request, $superviseId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can perform this action.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $researchSupervise = ResearchSupervise::find($superviseId);

        if (!$researchSupervise) {
            return response()->json([
                'success' => false,
                'message' => 'Research Supervise record (meeting) not found.'
            ], 404);
        }

        $research = Research::find($researchSupervise->research_id);
        if (!$research || !$research->supervisors->contains('supervisor_id', $staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'You are not authorized to approve/disapprove this meeting.'
            ], 403);
        }

        $researchSupervise->status = ($researchSupervise->status == 1) ? null : 1;
        $researchSupervise->save();

        return response()->json([
            'success' => true,
            'message' => 'Supervise meeting approval status toggled successfully.',
            'new_status' => $researchSupervise->status
        ]);
    }

    public function getResearchDefenseApprovals($researchId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can access this resource.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $research = Research::where('id', $researchId)
            ->whereHas('supervisor', function($q) use ($staffId) {
                $q->where('supervisor_id', $staffId);
            })
            ->with(['predefenseApproval.staff', 'finaldefenseApproval.staff', 'seminarApproval.staff'])
            ->first();

        if (!$research) {
            return response()->json([
                'success' => false,
                'message' => 'Research not found or you are not the supervisor.'
            ], 404);
        }

        $approvals = [
            'predefense' => $research->predefenseApproval,
            'finaldefense' => $research->finaldefenseApproval,
            'seminar' => $research->seminarApproval,
        ];

        return response()->json([
            'success' => true,
            'data' => $approvals
        ]);
    }

    public function toggleDefenseApprovalDecision(Request $request, $approvalId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can perform this action.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $defenseApproval = DefenseApproval::find($approvalId);

        if (!$defenseApproval) {
            return response()->json([
                'success' => false,
                'message' => 'Defense Approval record not found.'
            ], 404);
        }

        if ($defenseApproval->staff_id != $staffId) {
             return response()->json([
                'success' => false,
                'message' => 'You are not authorized to modify this approval record.'
            ], 403);
        }

        if ($defenseApproval->decision == 1) {
            $defenseApproval->decision = null;
            $defenseApproval->approval_date = null;
        } else {
            $defenseApproval->decision = 1;
            $defenseApproval->approval_date = Carbon::now();
        }
        $defenseApproval->save();

        $research = Research::find($defenseApproval->research_id);
        if ($research) {
            $this->updateResearchMilestoneBasedOnApprovals($research);
        }

        return response()->json([
            'success' => true,
            'message' => 'Defense approval decision toggled successfully.',
            'new_decision' => $defenseApproval->decision
        ]);
    }

    protected function updateResearchMilestoneBasedOnApprovals(Research $research)
    {
        // Pre-defense
        if ($research->predefenseApproval->count() > 0 &&
            $research->predefenseApproval->count() == $research->predefenseApproved->count()) {
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')->where('phase', 'Approved')->first()->id,
            ]);
        } else if ($research->predefenseApproval->count() > 0) {
             $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')->where('phase', 'Submitted')->first()->id,
            ]);
        }

        // Final-defense
        if ($research->finaldefenseApproval->count() > 0 &&
            $research->finaldefenseApproval->count() == $research->finaldefenseApproved->count()) {
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                ->where('phase', 'Approved')->where('sequence', 12)->first()->id,
            ]);
            if (is_null($research->PUBAPPROVED)) {
                ResearchLog::create([
                    'research_id' => $research->id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','PUBAPPROVED')->first()->id,
                    'message' => ResearchLogType::where('code','PUBAPPROVED')->first()->description,
                    'status' => 1,
                ]);
            }
        } else if ($research->finaldefenseApproval->count() > 0) {
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                ->where('phase', 'Submitted')->where('sequence', 11)->first()->id,
            ]);
        }

        // Seminar
        if ($research->seminarApproval->count() > 0 &&
            $research->seminarApproval->count() == $research->seminarApproved->count()) {
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Seminar')
                                ->where('phase', 'Approved')->where('sequence', 6)->first()->id,
            ]);
            if (is_null($research->SEMAPPROVED)) {
                ResearchLog::create([
                    'research_id' => $research->id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','SEMAPPROVED')->first()->id,
                    'message' => ResearchLogType::where('code','SEMAPPROVED')->first()->description,
                    'status' => 1,
                ]);
            }
        } else if ($research->seminarApproval->count() > 0) {
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Seminar')
                                ->where('phase', 'Submitted')->where('sequence', 5)->first()->id,
            ]);
        }

        $research->save();
    }

    public function getResearchSuperviseMeetingDetails($superviseId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can access this resource.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $superviseMeeting = ResearchSupervise::where('id', $superviseId)
            ->with(['research.supervisors', 'discussions.discussant']) // Load related research and discussions
            ->first();

        if (!$superviseMeeting) {
            return response()->json([
                'success' => false,
                'message' => 'Supervise meeting not found.'
            ], 404);
        }

        // Ensure the authenticated staff is a supervisor for this research supervise record
        if (!$superviseMeeting->research->supervisors->contains('supervisor_id', $staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'You are not authorized to view this meeting.'
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $superviseMeeting
        ]);
    }

    public function addResearchSuperviseDiscussion(Request $request, $superviseId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can perform this action.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $superviseMeeting = ResearchSupervise::find($superviseId);

        if (!$superviseMeeting) {
            return response()->json([
                'success' => false,
                'message' => 'Supervise meeting not found.'
            ], 404);
        }

        // Ensure the authenticated staff is a supervisor for this research supervise record
        if (!$superviseMeeting->research->supervisors->contains('supervisor_id', $staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'You are not authorized to add discussion to this meeting.'
            ], 403);
        }

        $request->validate([
            'message' => 'required|string',
        ]);

        $discussion = ResearchSuperviseDiscussion::create([
            'supervise_id' => $superviseId,
            'discussant_id' => $user->id, // Assuming discussant_id refers to user_id
            'message' => $request->input('message'),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Discussion added successfully.',
            'data' => $discussion
        ], 201);
    }

    public function deleteResearchSuperviseDiscussion($discussionId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only staff can perform this action.'
            ], 403);
        }

        $staffId = $user->staff->id ?? null;

        if (is_null($staffId)) {
             return response()->json([
                'success' => false,
                'message' => 'Staff profile not found for the authenticated user.'
            ], 403);
        }

        $discussion = ResearchSuperviseDiscussion::find($discussionId);

        if (!$discussion) {
            return response()->json([
                'success' => false,
                'message' => 'Discussion record not found.'
            ], 404);
        }

        // Ensure the authenticated user is the one who posted the discussion
        if ($discussion->discussant_id != $user->id) {
             return response()->json([
                'success' => false,
                'message' => 'You are not authorized to delete this discussion.'
            ], 403);
        }

        $discussion->delete();

        return response()->json([
            'success' => true,
            'message' => 'Discussion deleted successfully.'
        ]);
    }

    public function toggleExaminerPresence(Request $request, $examinerId)
    {
        $user = Auth::user();

        if (!$user || !$user->hasRole('staff')) {
            return response()->json(['success' => false, 'message' => 'Unauthorized.'], 403);
        }

        $defenseExaminer = DefenseExaminer::find($examinerId);

        if (!$defenseExaminer) {
            return response()->json(['success' => false, 'message' => 'Examiner not found.'], 404);
        }

        $research = $defenseExaminer->defenseApplicant->research;
        $applicantId = $defenseExaminer->applicant_id;

        $examinerPresenceCount = DefenseExaminer::where('applicant_id', $applicantId)
            ->whereHas('defenseExaminerPresence')
            ->count();

        if (is_null($defenseExaminer->defenseExaminerPresence)) {
            if ($examinerPresenceCount < 3) {
                DefenseExaminerPresence::create([
                    'defense_examiner_id' => $examinerId,
                    'event_id' => $defenseExaminer->event_id,
                    'examiner_id' => $defenseExaminer->examiner_id,
                ]);
            } else {
                return response()->json(['success' => false, 'message' => 'The maximum number of examiners has been reached'], 400);
            }
        } else {
            $defenseExaminer->defenseExaminerPresence->delete();
        }

        if ($research->supervisor) {
            foreach ($research->supervisor as $supervisor) {
                if (is_null($supervisor->defenseSupervisorPresence)) {
                    DefenseSupervisorPresence::create([
                        'research_supervisor_id' => $supervisor->id,
                        'event_id' => $defenseExaminer->event_id,
                        'supervisor_id' => $supervisor->staff->id,
                        'research_id' => $supervisor->research->id,
                    ]);
                }
            }
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')
                                    ->where('phase', 'Done')->first()->id,
            ]);

            if (is_null($research->DEFDONE)) {
                ResearchLog::create([
                    'research_id' => $research->id,
                    'type_id' =>  ResearchLogType::where('code', 'DEFDONE')->first()->id,
                    'loger_id' => Auth::user()->id,
                    'message' => ResearchLogType::where('code', 'DEFDONE')->first()->description,
                    'status' => 1,
                ]);
            }
        }

        return response()->json(['success' => true, 'message' => 'Examiner presence toggled successfully.']);
    }

    public function getDefenseParticipantDetails($participantId)
    {
        $user = Auth::user();
        if (!$user || !$user->hasRole('staff')) {
            return response()->json(['success' => false, 'message' => 'Unauthorized.'], 403);
        }

        $participant = EventApplicantDefense::with([
            'research.student',
            'research.supervisors.staff',
            'examiners.staff',
            'examiners.defenseExaminerPresence'
        ])->find($participantId);

        if (!$participant) {
            return response()->json(['success' => false, 'message' => 'Participant not found.'], 404);
        }

        $participant->load('research.supervisors.staff');

        $staffId = $user->staff->id;
        $isSupervisor = $participant->research->supervisors->contains('supervisor_id', $staffId);

        return response()->json([
            'success' => true,
            'data' => [
                'participant' => $participant,
                'is_supervisor' => $isSupervisor,
            ]
        ]);
    }

    public function submitScore(Request $request, $participantId)
    {
        $user = Auth::user();
        if (!$user || !$user->hasRole('staff')) {
            return response()->json(['success' => false, 'message' => 'Unauthorized.'], 403);
        }

        $request->validate([
            'score' => 'required|numeric|min:0|max:100',
        ]);

        $participant = EventApplicantDefense::find($participantId);

        if (!$participant) {
            return response()->json(['success' => false, 'message' => 'Participant not found.'], 404);
        }

        // Add authorization logic here if needed

        $participant->score = $request->input('score');
        $participant->save();

        return response()->json(['success' => true, 'message' => 'Score submitted successfully.']);
    }

    public function getFinalDefenseEvents(Request $request)
    {
        $user = Auth::user();
        if (!$user || !$user->hasRole('staff')) {
            return response()->json(['success' => false, 'message' => 'Unauthorized.'], 403);
        }

        $events = Event::where('status', 1)
            ->where('event_type_id', 2)
            ->whereHas('finaldefenseApplicantPublish', function($query){
                $query->whereHas('research', function($query){
                    $query->whereHas('supervisor', function($query){
                        $query->where('supervisor_Id', Auth::user()->staff->id);
                    });
                })
                ->orWhereHas('room', function($query){
                    $query->whereHas('examiner', function($query){
                        $query->where('examiner_id', Auth::user()->staff->id);
                    });
                });
            })
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 5, $columns = ['*'], $pageName = 'eventOfDefense');

        return response()->json([
            'success' => true,
            'data' => $events
        ]);
    }
}
