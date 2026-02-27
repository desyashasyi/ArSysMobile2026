<?php

namespace App\Models\ArSys;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Research extends Model
{
    use HasFactory;
    //use \Awobaz\Compoships\Compoships;
    protected $guarded = [];
    protected $fillable = [];
    protected $table = 'arsys_research';

    public static function boot() {
        parent::boot();

        static::deleting(function($research) {
            $research->history()->delete();
            $research->proposalFile()->delete();
            $research->remark()->delete();
            $research->supervise()->delete();
            $research->proposalReview()->delete();
            $research->supervisor()->delete();
            $research->supervisorexternal()->delete();
            //$research->defenseApproval()->delete();

        });
    }
   
    /**
     * Research Milestone
     */
    public function milestone(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id');
    }

    public function milesPREDEFDONE(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id')
            ->where('code', 'Pre-defense')->where('phase','Done');
    }

    /*public function milestone(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id');
    }
    /*public function milestonelog(){
        return $this->hasMany(ResearchMilestoneLog::class, 'research_id', 'id');
    }*/

    public function supervise(){
        return $this->hasMany(ResearchSupervise::class, 'research_id', 'id');
    }

    public function proposalFile(){
        return $this->hasMany(ResearchFile::class, 'research_id', 'id')->where('file_type', 1);
    }

    public function proposalReview(){
        return $this->hasMany(ResearchReview::class, 'research_id', 'id');
    }


    public function supervisor(){
        return $this->hasMany(ResearchSupervisor::class, 'research_id', 'id');
    }
    public function supervisorExtra(){
        return $this->hasOne(ResearchSupervisorExtra::class, 'research_id', 'id');
    }
    
    

    public function supervisorexternal(){
        return $this->hasOne(ResearchSupervisorExternal::class, 'research_id', 'id');
    }

    public function supervisordummy(){
        return $this->hasMany(ResearchSupervisorDummy::class, 'research_id', 'id');
    }

    public function supervisorexternaldummy(){
        return $this->hasOne(ResearchSupervisorExternalDummy::class, 'research_id', 'id');
    }

    /**
     * Type of research
     */
    public function type(){
        return $this->belongsTo(ResearchType::class,  'type_id', 'id');
    }

    public function programSeminar(){
        return $this->belongsTo(ResearchType::class,  'type_id', 'id')
            ->where('research_type_base_id', ResearchTypeBase::where('code','SP')->first()->id);
    }

    public function industrialSeminar(){
        return $this->belongsTo(ResearchType::class,  'type_id', 'id')
            ->where('research_type_base_id', ResearchTypeBase::where('code','PI')->first()->id);
    }


    public function student(){
        return $this->belongsTo(Student::class, 'student_id', 'id');
    }

    public function defenseApproval(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id');
    }

    public function predefApproval(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id');
    }

    public function approvalRequest(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')->where('decision', null);
    }

   
    public function waiting(){
        return $this->hasMany(EventApplicantWaiting::class, 'research_id', 'id');
    }

    public function file(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id');
    }
    public function todo(){
        return $this->hasMany(Todo::class, 'research_id', 'id')->where('completed','=', 0);;
    }

    public function completedtodo(){
        return $this->hasMany(Todo::class, 'research_id', 'id')->where('completed','=', 1);
    }

    public function thesisdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'THESIS')->first()->id);
    }

    public function draftthesisdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'DRAFTTHESIS')->first()->id);
    }

    public function spvdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'SPV')->first()->id);
    }

    public function cospvdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'COSPV')->first()->id);
    }

    public function pdfartdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'PDFART')->first()->id);
    }

    public function STEThesis(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'DRAFTTHESIS')->first()->id);
    }

    public function docxartdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'DOCXART')->first()->id);
    }

    public function pptdoc(){
        return $this->hasOne(ResearchFile::class, 'research_id', 'id')->where('file_type', ResearchFileType::where('code', 'PPTART')->first()->id);
    }

    public function endprojectresearch(){
        return $this->hasMany(EndResearch::class, 'username', 'username');
    }

    public function reviewDiscussion(){
        return $this->hasMany(ResearchReviewDiscussion::class, 'research_id', 'id');
    }

    public function reviewDiscussionRead(){
        return $this->hasMany(ResearchReviewDiscussionRead::class, 'research_id', 'id');
    }

    public function SIASProPre(){
        return $this->hasOne(ResearchSIAS::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PRO')->first()->id)->where('approval', null);
    }

    

    public function SIASFinalPre(){
        return $this->hasOne(ResearchSIAS::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PUB')->first()->id)->where('approval', null);
    }

    public function SIASFinal(){
        return $this->hasOne(ResearchSIAS::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PUB')->first()->id)->where('approval', 1);
    }


    public function TurnitinPredefense(){
        return $this->hasOne(ResearchTurnitin::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PRE')->first()->id);
    }

    public function TurnitinPrePre(){
        return $this->hasOne(ResearchTurnitin::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PRE')->first()->id)->where('approval', null)->where('score', null);
    }

    public function TurnitinPre(){
        return $this->hasOne(ResearchTurnitin::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PRE')->first()->id)->where('approval', 1)->where('score', null);
    }

    public function TurnitinPreScore(){
        return $this->hasOne(ResearchTurnitin::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PRE')->first()->id)->where('approval', 1)->where('score','!=',null);
    }

    public function TurnitinFinalPre(){
        return $this->hasOne(ResearchTurnitin::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PUB')->first()->id)->where('approval', null);
    }

    public function TurnitinFinal(){
        return $this->hasOne(ResearchTurnitin::class, 'research_id', 'id')->where('event_type', EventType::where('code', 'PUB')->first()->id)->where('approval', 1);;
    }

    public function history(){
        return $this->hasMany(ResearchLog::class, 'research_id', 'id');
    }
    
    /**
     * Research status
     */
    public function write(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'CRE')->first()->id)
            ->where('status', 1);
    }
    public function active(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'ACT')->first()->id)
            ->where('status', 1);
    }
    
    public function submit(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SUB')->first()->id)
            ->where('status', 1);
    }
    public function review(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'REV')->first()->id)
            ->where('status', 1);
    }
    public function reviewer(){
        return $this->hasMany(ResearchReview::class, 'research_id', 'id');
    }
    public function freeze(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'FRE')->first()->id)
            ->where('status', 1);
    }
    public function rejected(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'RJC')->first()->id)
            ->where('status', 1);
    }
    public function renewal(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'REN')->first()->id)
            ->where('status', 1);
    }

    public function renewed(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'REN')->first()->id)
            ->where('status', null);
    }


    /**
     * Pre-defense status
     */
    public function DEFAPPREQ(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'DEFAPPREQ')->first()->id)
            ->where('status', 1);
    }
    public function DEFAPPROVED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'DEFAPPROVED')->first()->id)
            ->where('status', 1);
    }

    public function DEFAPPLIED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'DEFAPPLIED')->first()->id)
            ->where('status', 1);
    }

    public function DEFSCHEDULED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'DEFSCHEDULED')->first()->id)
            ->where('status', 1);
    }

    public function DEFDONE(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'DEFDONE')->first()->id)
            ->where('status', 1);
    }

    
    /**
     * Final-defense status
     */
    public function PUBAPPREQ(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'PUBAPPREQ')->first()->id)
            ->where('status', 1);
    }
    public function PUBAPPROVED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'PUBAPPROVED')->first()->id)
            ->where('status', 1);
    }

    public function PUBAPPLIED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'PUBAPPLIED')->first()->id)
            ->where('status', 1);
    }

    public function PUBSCHEDULED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'PUBSCHEDULED')->first()->id)
            ->where('status', 1);
    }

    public function PUBDONE(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'PUBDONE')->first()->id)
            ->where('status', 1);
    }


    public function spvLetter(){
        return $this->hasOne(ResearchLetter::class, 'research_id', 'id')
            ->where('research_letter_base_id', ResearchLetterBase::where('code', 'SPV-TA')->first()->id);
    }

    public function SIASPro(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SIASPRO')->first()->id)
            ->where('status', 1);
    }
    public function approval(){
        return $this->hasMany(ResearchLog::class, 'research_id', 'id')->where('type_id', ResearchLogType::where('code','ACT')->first()->id);
    }

    /*public function renewal(){
        return $this->hasMany(ResearchApprovalRenewal::class, 'research_id', 'id');
    }*/



    public function remark(){
        return $this->hasMany(ResearchRemark::class, 'research_id', 'id');
    }

    public function disableSuperviseDuration(){
        return $this->hasOne(ResearchSuperviseDurationDisable::class, 'research_id', 'id');
    }

    /**
     * Pre defense
     */
    public function milesPredefenseProgress(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id')
        ->where('code', 'Pre-defense')
        ->where('phase', 'In progress')->where('sequence', 4);
    }

    public function predefenseApproval(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id);
    }
    public function predefenseApproved(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id)
        ->where('decision', 1);
    }

    public function predefenseApplied(){
        return $this->hasOne(EventApplicantDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id);
    }
    public function predefenseReported(){
        return $this->hasOne(EventApplicantDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id)
        ->where('status',1);
    }

    public function predefenseUnconfirmed(){
        return $this->hasOne(EventApplicantDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id)
        ->where('confirmed', null);
    }
    public function predefensePublished(){
        return $this->hasOne(EventApplicantDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id)
        ->where('confirmed', 1)->where('publish',1);
    }


    /**
     * Final Defense
     */
    public function milesFinaldefenseProgress(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id')
        ->where('code', 'Final-defense')
        ->where('phase', 'In progress')->where('sequence', 10);
    }
    public function finaldefenseApproval(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id);
        
    }
    public function finaldefenseApproved(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)
        ->where('decision', 1);
    }

    public function milesFinaldefenseApproved(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id')
        ->where('code', 'Final-defense')
        ->where('phase', 'Approved')->where('sequence', 12);
    }

    public function finaldefenseApplied(){
        return $this->hasOne(EventApplicantFinalDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id);
    }

    public function finaldefenseUnconfirmed(){
        return $this->hasOne(EventApplicantFinalDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)
        ->where('confirmed', null);
    }
    public function finaldefensePublished(){
        return $this->hasOne(EventApplicantFinalDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)
        ->where('confirmed', 1)->where('publish', 1);
    }

    public function finaldefenseAExtra(){
        return $this->hasOne(EventApplicantFinalDefenseExtra::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id);
    }
    public function finaldefenseAdd(){
        return $this->hasOne(EventApplicantAddFinalDefense::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id);
    }


    /*
    public function predefenseApprovalRequest(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')->where('decision', null)
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id);
    }
    public function predefenseApproved(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')->where('decision', 1)
        ->where('defense_model_id', DefenseModel::where('code', 'PRE')->first()->id);
    }
    */

    


    

    public function milesSeminarProgress(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id')
        ->where('code', 'Seminar')
        ->where('phase', 'In progress')->where('sequence', 4);
    }

    public function milesSeminarApproved(){
        return $this->belongsTo(ResearchMilestone::class, 'milestone_id', 'id')
        ->where('code', 'Seminar')
        ->where('phase', 'Approved')->where('sequence', 6);
    }


    public function seminarApproval(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'SEM')->first()->id);
    }
    public function seminarApproved(){
        return $this->hasMany(DefenseApproval::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'SEM')->first()->id)
        ->where('decision', 1);
    }
    public function seminarApplied(){
        return $this->hasOne(EventApplicantSeminar::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'SEM')->first()->id);
    }

    public function seminarUnconfirmed(){
        return $this->hasOne(EventApplicantSeminar::class, 'research_id', 'id')
        ->where('defense_model_id', DefenseModel::where('code', 'SEM')->first()->id)
        ->where('confirmed', null);
    }
    /**
     * Seminar status
     */
    public function SEMAPPREQ(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SEMAPPREQ')->first()->id)
            ->where('status', 1);
    }
    public function SEMAPPROVED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SEMAPPROVED')->first()->id)
            ->where('status', 1);
    }

    public function SEMAPPLIED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SEMAPPLIED')->first()->id)
            ->where('status', 1);
    }

    public function SEMSCHEDULED(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SEMSCHEDULED')->first()->id)
            ->where('status', 1);
    }

    public function SEMDONE(){
        return $this->hasOne(ResearchLog::class, 'research_id', 'id')
            ->where('type_id', ResearchLogType::where('code', 'SEMDONE')->first()->id)
            ->where('status', 1);
    }



    



    

    
}
