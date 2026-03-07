<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ArSys Defense Schedule</title>

    <style type="text/css">

#tablejadwal {
  font-family: "Times New Roman", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
  margin: 0px 0px 0px 0px;
}


hr {
    display: block;
    height: 2px;
    border: 0;
    border-top: 1px solid #444;
    margin: 1em 0;
    padding: 0px 25px 0px 25px;
}

#kop {
  width: 100%;
  margin: 25px 25px 25px 25px;
  font-size: 20px;
  vertical-align: top;
}


#tablejadwal td, #tablejadwal th {
  border: 1px solid #666;
  padding: 4px;
  vertical-align: top;
}

#bodysurat {
  font-family: "Times New Roman", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
  margin: 25px 25px 25px 25px;
  font-size: 13px;
}

#tablejadwal th {
  padding-top: 5px;
  padding-bottom: 5px;
  padding-right: 5px;
  padding-left: 5px;
  text-align: left;
  background-color: #ddd;
  color: #000;
}

        .page-break {
            page-break-after: always;
        }
        @page {
            margin: 30px;
        }
        body {
            margin: 0px;
        }
        * {
            font-family: times;
        }

        table {
            font-size: small;
            border-collapse: collapse;
        }

        h2 {
            margin: 0;
            font-size: 15px;
        }
        h5 {
            margin: 0;
            font-size: 10px;
        }
        footer{
            position: fixed;
            bottom: 0cm;
            left: 0cm;
            right: 0cm;
            height: 1cm;

                /** Extra personal styles **/
            background-color: #03a9f4;
            color: white;
            text-align: center;
            line-height: 0.7cm;
        }

    </style>

</head>
<body>
    @php(\Carbon\Carbon::setLocale('id'))
    <div id="kop">
        <table width="100%">
            <tr>
                <td align ="center" style="width: 100%">
                    @if($event)
                        <h2>Schedule of {{$event->program->abbrev}}'s {{$event->type->description}} |
                        {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                        {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                        {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                        </h5>
                    @endif
                </td>
            </tr>
        </table>
    </div>
    <div id="tablejadwal">
        <table width="100%">
            <thead>
                <tr>
                    <th width="20%">Schedule</th>
                    <th width="30%">Examiner</th>
                    <th width="40%">Applicants</th>
                </tr>
            </thead>
            <tbody>
    @foreach($rooms as $index => $room)
       
       
                    <tr>
                        <td>
                            <span>
                                <i  class="fa fa-xs fa-building" ></i>
                                <u>Space</u>
                            </span>
                            <br>
                            @if($room->space)
                                {{$room->space->description}}
                            @endif
                            <br>
                            <br>

                            <span>
                                <i  class="fa fa-xs fa-clock" ></i>
                                <u>Session</u>
                            </span>
                            <br>
                            @if($room->session)
                                {{$room->session->time}}
                            @endif

                        </td>
                        <td>
                            <span>
                                <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                <u>Moderator</u>
                            </span>
                            <br>
                            @if(!is_null($room->moderator))
                                {{$room->moderator->front_title}}
                                {{$room->moderator->first_name}} 
                                {{$room->moderator->last_name}},
                                {{$room->moderator->reari_title}}
                            @endif
                            <br>
                            <br>

                            <span>
                                <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                <u>Examiner(s)</u>
                            </span>
                            <br>
                            @foreach($room->examiner as $index => $examiner)
                                {{$examiner->staff->front_title}}
                                {{$examiner->staff->first_name}} 
                                {{$examiner->staff->last_name}}
                                {{$examiner->staff->rear_title}}
                                <br>
                            @endforeach
                        </td>
                        <td>
                            @foreach($room->applicant as $index => $applicant)
                                @if($applicant->research->student->program_id != Auth::user()->staff->program->id)
                                    <span style="color:gray">
                                        {{$index+1}}.
                                        {{$applicant->research->student->first_name}}
                                        {{$applicant->research->student->last_name}}
                                        ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                    </span>
                                @else
                                    {{$index+1}}.
                                    {{$applicant->research->student->first_name}}
                                    {{$applicant->research->student->last_name}}
                                    ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                @endif
                                <br>
                            @endforeach
                        </td>
                    </tr>
                
    @endforeach
</tbody>
</table>
{{--
</div>
    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
            <td width="70%"> </td>
            <td width="30%">Ketua Program Studi, <br /><br />
                    
                <img src="{{ public_path().'/images/'.$program->staff->code.'.png'}}" width="100" height="100"/>
                <br>
                <br>
                {{$program->staff->front_title}}
                {{$program->staff->first_name}}
                {{$program->staff->last_name}}.
                {{$program->staff->rear_title}}
                <br>
                NIP: {{$program->staff->employee_id}}
            </td>
            </tr>
            </tbody>
        </table>
    </div>
    --}}
</body>
</html>
