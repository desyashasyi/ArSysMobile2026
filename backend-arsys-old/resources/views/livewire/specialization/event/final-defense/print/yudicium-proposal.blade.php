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
                <td text-align ="left" style="width: 100%">
                    LAMPIRAN:
                </td>
            </tr>
            <tr>
                <td align ="center" style="width: 100%">
                    SURAT KEPUTUSAN DEKAN FPTK
                    <br>
                    UNIVERSITAS PENDIDIKAN INDONESIA
                    <br>
                    <br>
                    TENTANG PENETAPAN PANITIA, PENGUJI, DAN PESERTA UJIAN SIDANG
                    {{Str::upper($program->title_id)}}
                    <br>
                    PROGRAM STUDI {{Str::upper($program->name)}}  – S1

                    <br>
                    FPTK UNIVERSITAS PENDIDIKAN INDONESIA
                    <br>PERIODE BULAN  {{ Str::upper(\Carbon\Carbon::parse($event->event_date)->translatedformat('F Y'))}} <br />
                    <br>
                    <br>
                    SK NO.
                </td>
            </tr>
        </table>
    </div>
    <hr/>
    <b>
       {{Str::upper($program->name)}}
    </b>
    <br>
    <br>
    <div id="tablejadwal">
        <table width="100%">
            <thead>
                <tr>
                    <th width="2%">No</th>
                    <th width="18%">NIM dan Nama</th>
                    <th width="20%">Judul</th>
                    <th width="20%">Pembimbing</th>
                    <th width="20%">Penguji</th>
                    <th width="20%"></th>
                </tr>
            </thead>
            <tbody>
                @php($counter = 0)
                @php($done = null)
                @foreach($applicants as $index => $applicant)
                    <tr>
                        <td class="text-center">
                            {{++$counter}}
                        </td>
                        <td>
                            {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                            <br>
                            {{$applicant->research->student->first_name}}
                            {{$applicant->research->student->last_name}}
                        </td>

                        <td>
                            {!!Str::upper($applicant->research->title)!!}
                        </td>
                        <td>
                            @foreach($applicant->research->supervisor as $index => $supervisor)
                                {{$supervisor->staff->front_title}}
                                {{$supervisor->staff->first_name}}
                                {{$supervisor->staff->last_name}}
                                {{$supervisor->staff->rear_title}}
                                <br>
                            @endforeach
                        </td>
                        <td>
                            @if(!is_null($applicant->research->predefenseApplied))
                                @foreach($applicant->research->predefenseApplied->defenseExaminer as $examiner)
                                    @if($examiner->defenseExaminerPresence)
                                        {{$examiner->staff->front_title}}
                                        {{$examiner->staff->first_name}}
                                        {{$examiner->staff->last_name}}
                                        {{$examiner->staff->rear_title}}
                                        <br>
                                    @endif
                                @endforeach
                            @endif
                        </td>
                        @if($index < 5 && is_null($done))
                            @php($done = 1)
                            <td rowspan="4">
                                <b>Penanggung Jawab:</b>
                                <br>Rektor UPI
                                <br>Prof. Dr. Didi Sukyadi, M.A.
                                <br>
                                <br>
                                <b>Ketua:</b>
                                <br>Dekan FPTK UPI
                                <br>Dr. Eng. Agus Setiawan, M.Si.
                                <br>
                                <br>
                                <b>Anggota:</b>
                                <br>Wakil Dekan I FPTK UPI
                                <br>Iwan Kustiawan, Ph.D.

                                <br>
                                <br>
                                Ketua Prodi {{$program->name}}
                                <br>
                                {{$program->staff->front_title}}
                                {{$program->staff->first_name}}
                                {{$program->staff->last_name}}
                                {{$program->staff->rear_title}}
                            </td>
                        @endif

                        @if($done == 1 && $counter >= 5)
                            <td></td>
                        @endif
                    </tr>
                @endforeach

                @if($waitingApplicants->isNotEmpty())
                    @foreach($waitingApplicants as $applicant)
                        @if(!is_null($applicant->research))
                            @if(!$applicants->contains('research_id', $applicant->research->id))
                                <tr>
                                    <td align="center">
                                        {{++$counter}}
                                    </td>
                                    <td>
                                        {{$applicant->research->student->program->code}}.
                                        {{$applicant->research->student->number}}
                                        <br>
                                        {{$applicant->research->student->first_name}}
                                        {{$applicant->research->student->last_name}}
                                    </td>

                                    <td>
                                        {{Str::upper($applicant->research->title)}}
                                    </td>
                                    <td>
                                        @foreach($applicant->research->supervisor as $index => $supervisor)
                                            {{$index+1}}.
                                            {{$supervisor->staff->front_title}}
                                            {{$supervisor->staff->first_name}}
                                            {{$supervisor->staff->last_name}}
                                            {{$supervisor->staff->rear_title}}
                                            <br>
                                        @endforeach
                                    </td>
                                    <td>
                                        @if(!is_null($applicant->research->predefenseApplied))
                                            @foreach($applicant->research->predefenseApplied->defenseExaminer as $examiner)
                                                @if($examiner->defenseExaminerPresence)
                                                    {{$examiner->staff->front_title}}
                                                    {{$examiner->staff->first_name}}
                                                    {{$examiner->staff->last_name}}
                                                    {{$examiner->staff->rear_title}}
                                                    <br>
                                                @endif
                                            @endforeach
                                        @endif

                                    </td>
                                    <td></td>
                                </tr>
                            @endif
                        @endif
                    @endforeach
                @endif
            </tbody>
        </table>
    </div>

    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
                <td width="70%" ></td>
                <td width="30%">Ditetapkan di: Bandung</td>
            </td>
            <tr>
                <td width="70%" ></td>
                <td width="30%">Pada Tanggal: </td>
                </td>
            </tr>

            <tr>
                <td width="70%"></td>
                <td width="30%">Dekan</td>
            </tr>
            <tr>
                <td width="70%"></td>
                <td width="30%">
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />
                <br />

                <b>Dr. Eng. Agus Setiawan, M.Si.</b>
                <br>
                NIP. 196902111993031001
            </td>
            </tr>
            </tbody>
        </table>
    </div>

</body>
</html>
