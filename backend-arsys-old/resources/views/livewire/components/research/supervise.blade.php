<div>
    @if($research)
        <div class="text-left col-md-12">
            <i class="fas fa-spinner"></i><b> Progress of Supervision</b>
            @if(Auth::user()->student)
                <i wire:click="superviseMeeting_ArSysStudentResearchSuperviseMeeting({{$research->id}})" style="color: green; cursor: pointer" class="fa fa-plus-circle"></i>
            @endif
            <br>
            @if($research->supervise->isEmpty())
                @if(Auth::user()->student)
                    <i style="color: red">
                        One of the mandatory rule of students'research is that student should have
                        at least six supervision meeting once a week.
                        So, please report you meeting by clicking the
                    <span style="color: gray" class="fa fa-plus-circle"></span> icon above.
                    </i>
                @endif
                @if(Auth::user()->staff)
                    <i style="color: red">
                        Student did not write any meeting report
                    </i>
                @endif
            @endif
        </div>
    @endif
    <livewire:student.research.components.supervise-meeting">
    <livewire:student.research.components.supervise-meeting-show">
</div>
