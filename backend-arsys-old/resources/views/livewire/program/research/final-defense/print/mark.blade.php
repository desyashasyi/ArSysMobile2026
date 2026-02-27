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
    @if($eventApplicants->isNotEmpty())
        <div id="tablejadwal">
            <table width="100%">
                <thead class="thead">
                    <tr>
                        <th rowspan="2" valign= "center" class="text-center" width="2%">No</th>
                        <th rowspan="2" valign= "center" width="25%">NIM</th>
                        <th rowspan="2" valign= "center" width="30%">Student</th>
                        <th class="text-center" width="15%" colspan="3">
                           Pembimbing
                        </th>
                        <th colspan="4" width="20%" class="text-center">
                            Penguji
                        </th>
                        <th rowspan="2" width="10%" class="text-center">
                            Nilai pra Sidang
                        </th>
                        <th rowspan="2" width="10%" class="text-center">
                            Nilai sidang Terbuka
                        </th>
                        <th rowspan="2" width="10%" class="text-center">
                            Nilai sidang 
                        </th>
                        <th rowspan="2" width="5%" class="text-center">
                            Predikat 
                        </th>
                        <th rowspan="2" width="5%" class="text-center">
                            Nilai Angka 
                        </th>
                        <th rowspan="2" width="10%" class="text-center">
                            IPK Yudisium
                        </th>
                        <th rowspan="2" width="5%" class="text-center">
                            L/TL
                        </th>
                        <th rowspan="2" width="5%" class="text-center">
                           Derajat
                        </th>
                        <th rowspan="2" width="5%" class="text-center">
                            Total SKS
                        </th>
                        <th rowspan="2" width="5%" class="text-center">
                            Peringkat
                        </th>
                    </tr>
                    <tr>
                        <th width="5%" class="text-center">
                            I
                        </th>
                        <th width="5%" class="text-center">
                            II
                        </th>
                        <th width="5%" class="text-center">
                            Rata2
                        </th>
                        <th width="5%" class="text-center">
                            I
                        </th>
                        <th width="5%" class="text-center">
                            II
                        </th>
                        <th width="5%" class="text-center">
                            III
                        </th>
                        <th width="5%" class="text-center">
                            Rata2
                        </th>
                    </tr>

                </thead>
                <tbody>
                    @php($counter = 0) 
                    @php($done = null)

                    @foreach ($eventApplicants as $index => $applicant)
                        <tr>
                            <td class="text-right">
                                {{$index+1}}
                            </td>
                            <td>
                                {{$applicant->research->student->program->code}}.
                                {{$applicant->research->student->number}}
                            </td>
                            <td>
                                {{$applicant->research->student->first_name}}
                                {{$applicant->research->student->last_name}}
                            </td>
                            @php($supervisorTotal = 0)
                            @foreach($applicant->research->supervisor as $supervisor)
                                <td class="text-center" width="5%">
                                    @if(!is_null($supervisor->defenseSupervisorPresence))
                                        @if(is_null($supervisor->defenseSupervisorPresence->score))
                                            -
                                        @else
                                            @php($supervisorTotal = $supervisorTotal+ $supervisor->defenseSupervisorPresence->score)
                                            {{$supervisor->defenseSupervisorPresence->score}}
                                        @endif
                                    @endif
                                </td>
                            @endforeach
                            @if($applicant->research->supervisor->count() == 1)
                                <td>
                                    &nbsp;
                                </td>
                            @endif
                            <td class="text-center">
                                {{number_format($supervisorTotal/$applicant->research->supervisor->count(), 2, ',','')}}
                            </td>      
                            
                            @php($examinerTotal = 0)
                            @php($examinerPresence = 0)
                            @foreach($applicant->research->predefensePublished->defenseExaminer as $examiner)
                                @if(!is_null($examiner->defenseExaminerPresence))
                                    <td class="text-left" width="5%">
                                        @if(is_null($examiner->defenseExaminerPresence->score))
                                            -
                                        @else
                                            @php($examinerTotal = $examinerTotal + $examiner->defenseExaminerPresence->score)
                                            {{$examiner->defenseExaminerPresence->score}}
                                        @endif
                                    </td>      
                                    @php($examinerPresence++)
                                @endif            
                            @endforeach
                                      
                            @if($examinerPresence == 2)
                                <td></td>
                            @endif
                          
                            <td>
                                {{number_format($examinerTotal/$applicant->research->predefensePublished->defenseExaminer->count(), 2, ',', '')}}
                            </td>    
                            <td>
                                &nbsp;
                            </td>   
                            
                            <td>
                                @php($examinerTotal = 0)
                                @php($examinerPresence = 0)
                                @foreach($applicant->research->finaldefensePublished->room->examiner as $examiner)
                                    @if(!is_null($examiner->presence))
                                        @if(!is_null($examiner->presence->score) || $examiner->presence->score != -1)
                                            @php($examinerTotal = $examinerTotal + $examiner->presence->score)
                                            @php($examinerPresence++)
                                        @endif
                                    @endif            
                                @endforeach
                                @if($examinerPresence != 0)
                                    {{number_format($examinerTotal/$examinerPresence, 2, ',', '')}}
                                @endif
                            </td>
                           <td></td>
                           <td></td>
                           <td></td>
                           <td></td>
                           <td></td>
                           <td></td>
                           <td></td>
                           <td></td>
                
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    @endif
</body>
</html>