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
                <td align ="right" style="width: 18%">
                <img src="{{ public_path().'/images/upi.png'}}" width="80" height="80"/>
                </td>
                <td class="text-right" style="width: 2%">

                </td>

                <td align ="left" style="width: 80%">

                  <b>KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET, DAN TEKNOLOGI<br />
                        UNIVERSITAS PENDIDIKAN INDONESIA <br />
                        FAKULTAS PENDIDIKAN TEKNOLOGI DAN KEJURUAN <br />
                        PROGRAM STUDI {{Str::upper($program->name)}}
                  </b>
                    <br>

                   Jl. Dr. Setiabudi No. 207 Bandung 40154 <br />Telp. (022) 2011576 Ext. 34001 s.d 34008, 34017 Fax (022) 2011576
                </td>
            </tr>
        </table>
    </div>
    <hr/>

    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
                <td text-align="left" width="9%">
                    Nomor
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">

                    @if($letter != null)
                        {{$letter->number}}{{$program->letter_code}}
                    @endif
                </td>
            </tr>
            <tr>
                <td text-align="left" width="9%">
                    Lampiran
                </td>
                <td text-align="left" width="1%">
                    : 
                </td>
                <td text-align="left" width="90%">
                    Satu berkas
                </td>
            </tr>
            <tr>
                <td text-align="left" width="9%">
                    Perihal
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    Permohonan Surat Keputusan Pelaksanaan Sidang Sarjana {{$program->name}}
                </td>
            </tr>
            <tr>
                <td text-align="left" colspan="3">
                    <br>
                </td>
            </tr>

            <tr>
                <td text-align="left" valign="top" width="9%">
                    Kepada
                </td>
                <td text-align="left" valign="top" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    Bapak Dekan FPTK UPI
                    <br>
                    di
                    <br>
                    Tempat
                </td>
            </tr>
            <tr>
                <td text-align="left" colspan="3">
                    <br>
                </td>
            </tr>
            <tr>
                <td text-align="left" valign="top" width="9%">
                </td>
                <td text-align="left" valign="top" width="1%">
                </td>
                <td text-align="left" width="90%">
                    Dengan hormat,
                    <br>
                    <br>
                    Sehubungan dengan pelaksanaan Sidang Sarjana
                    {{$program->name}} pada tanggal {{ \Carbon\Carbon::parse($event->event_date)->translatedformat('d F Y')}},

                    maka kami mengajukan permohonan SK pelaksanaan Sidang Sarjana
                    untuk peserta sidang sesuai lampiran.

                    <br>
                    <br>
                    Demikian permohon ini diajukan, terima kasih.

                </td>
            </tr>
            </tbody>
        </table>
    </div>



    <div id="bodysurat">
        <table width="100%">
            <tbody>
                <tr>
                    <td width="10%">
                    </td>
                    <td width="90%">

                    </td>
                </tr>

            </tbody>
        </table>
    </div>


    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
            <td width="70%"> </td>
            <td width="30%">Bandung,
                @if($letter != null)
                    @if(!is_null($letter))
                        {{ \Carbon\Carbon::parse($letter->date)->translatedformat('d F Y')}}.
                        {{--{{ \Carbon\Carbon::parse($letter->date)->translatedformat('d F Y')}} <br />--}}
                    @endif
                    <br>
                    Ketua Program Studi, <br /><br />
                    <img src="{{ public_path().'/images/'.$program->staff->code.'.png'}}" width="100" height="100"/>
                    <br>
                    <br>
                    {{$program->staff->front_title}}
                    {{$program->staff->first_name}}
                    {{$program->staff->last_name}}.
                    {{$program->staff->rear_title}}
                    <br>
                    NIP: {{$program->staff->employee_id}}
                @endif
            </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="page-break"></div>

    <div id="kop">
        <table width="100%">
            <tr>
                <td align ="right" style="width: 18%">
                <img src="{{ public_path().'/images/upi.png'}}" width="80" height="80"/>
                </td>
                <td class="text-right" style="width: 2%">

                </td>

                <td align ="left" style="width: 80%">

                  <b>KEMENTERIAN PENDIDIKAN DAN KEBUDAYAAN<br />
                        UNIVERSITAS PENDIDIKAN INDONESIA <br />
                        FAKULTAS PENDIDIKAN TEKNOLOGI DAN KEJURUAN <br />
                        PROGRAM STUDI {{Str::upper($program->name)}}
                  </b>
                    <br>

                   Jl. Dr. Setiabudi No. 207 Bandung 40154 <br />Telp. (022) 2011576 Ext. 34001 s.d 34008, 34017 Fax (022) 2011576
                </td>
            </tr>
        </table>
    </div>
    <hr/>

    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
                <td text-align="left" width="9%">
                    Nomor
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    @if($letter != null)
                        {{$letter->number}}{{$program->letter_code}}
                    @endif
                </td>
            </tr>
            <tr>
                <td text-align="left" width="9%">
                    Lampiran
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    -
                </td>
            </tr>
            <tr>
                <td text-align="left" width="9%">
                    Perihal
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    Undangan Pembukaan Sidang Yudisium Program Studi {{$program->name}}
                </td>
            </tr>
            <tr>
                <td text-align="left" colspan="3">
                    <br>
                </td>
            </tr>

            <tr>
                <td text-align="left" valign="top" width="9%">
                    Kepada
                </td>
                <td text-align="left" valign="top" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    Bapak Dekan FPTK UPI
                    <br>
                    di
                    <br>
                    Tempat
                </td>
            </tr>
            <tr>
                <td text-align="left" colspan="3">
                    <br>
                </td>
            </tr>
            <tr>
                <td text-align="left" valign="top" width="9%">
                </td>
                <td text-align="left" valign="top" width="1%">
                </td>
                <td text-align="left" width="90%">
                    Dengan hormat,
                    <br>
                    <br>
                    Dengan ini, kami memberitahukan bahwa Ujian Sidang Sarjana

                    {{$program->name}} FPTK UPI akan dilaksanakan tanggal
                    {{ \Carbon\Carbon::parse($event->event_date)->translatedformat('d F Y')}}.
                    Untuk itu, kami mengundang Bapak untuk membuka Sidang Yudisium tersebut pada pada:
                    <br>
                    <br>
                    <table width="100%">
                        <tbody>
                            <tr>
                                <td text-align="left" valign="top" width="15%">
                                    Hari, Tanggal
                                </td>
                                <td text-align="left" valign="top" width="1%">
                                    :
                                </td>
                                <td text-align="left" width="90%">
                                    {{ \Carbon\Carbon::parse($event->event_date)->translatedformat('d F Y')}}.
                                </td>
                            </tr>

                            <tr>
                                <td text-align="left" valign="top" width="15%">
                                    Waktu
                                </td>
                                <td text-align="left" valign="top" width="1%">
                                    :
                                </td>
                                <td text-align="left" width="90%">
                                    Pukul 07:00-selesai
                                </td>
                            </tr>

                            <tr>
                                <td text-align="left" valign="top" width="9%">
                                    Tempat
                                </td>
                                <td text-align="left" valign="top" width="1%">
                                    :
                                </td>
                                <td text-align="left" width="90%">
                                    Auditorium FPTK
                                </td>
                            </tr>
                            
                        </tbody>
                    </table>
                    <br>
                    Demikian undangan ini, atas perkenan Bapak kami ucapkan terima kasih.
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
            <td width="70%"> </td>
            <td width="30%">Bandung,
                @if($letter != null)
                    @if(!is_null($letter))
                        {{ \Carbon\Carbon::parse($letter->date)->translatedformat('d F Y')}}.
                        {{--{{ \Carbon\Carbon::parse($letter->date)->translatedformat('d F Y')}} <br />--}}
                    @endif
                    <br>
                    Ketua Program Studi, <br /><br />
                    <img src="{{ public_path().'/images/'.$program->staff->code.'.png'}}" width="100" height="100"/>
                    <br>
                    <br>
                    {{$program->staff->front_title}}
                    {{$program->staff->first_name}}
                    {{$program->staff->last_name}}.
                    {{$program->staff->rear_title}}
                    <br>
                    NIP: {{$program->staff->employee_id}}
                @endif
            </td>
            </tr>
            </tbody>
        </table>
    </div>

     <div class="page-break"></div>

    <div id="kop">
        <table width="100%">
            <tr>
                <td align ="right" style="width: 18%">
                <img src="{{ public_path().'/images/upi.png'}}" width="80" height="80"/>
                </td>
                <td class="text-right" style="width: 2%">

                </td>

                <td align ="left" style="width: 80%">

                  <b>KEMENTERIAN PENDIDIKAN DAN KEBUDAYAAN<br />
                        UNIVERSITAS PENDIDIKAN INDONESIA <br />
                        FAKULTAS PENDIDIKAN TEKNOLOGI DAN KEJURUAN <br />
                        PROGRAM STUDI {{Str::upper($program->name)}}
                  </b>
                    <br>

                   Jl. Dr. Setiabudi No. 207 Bandung 40154 <br />Telp. (022) 2011576 Ext. 34001 s.d 34008, 34017 Fax (022) 2011576
                </td>
            </tr>
        </table>
    </div>
    <hr/>

    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
                <td text-align="left" width="9%">
                    Nomor
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    @if($letter != null)
                        {{$letter->number}}{{$program->letter_code}}
                    @endif
                </td>
            </tr>
            <tr>
                <td text-align="left" width="9%">
                    Lampiran
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    -
                </td>
            </tr>
            <tr>
                <td text-align="left" width="9%">
                    Perihal
                </td>
                <td text-align="left" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    Undangan Pembukaan Sidang Yudisium Program Studi {{$program->name}}
                </td>
            </tr>
            <tr>
                <td text-align="left" colspan="3">
                    <br>
                </td>
            </tr>

            <tr>
                <td text-align="left" valign="top" width="9%">
                    Kepada
                </td>
                <td text-align="left" valign="top" width="1%">
                    :
                </td>
                <td text-align="left" width="90%">
                    Bapak Wakil Dekan Bidang Pendidikan FPTK UPI
                    <br>
                    di
                    <br>
                    Tempat
                </td>
            </tr>
            <tr>
                <td text-align="left" colspan="3">
                    <br>
                </td>
            </tr>
            <tr>
                <td text-align="left" valign="top" width="9%">
                </td>
                <td text-align="left" valign="top" width="1%">
                </td>
                <td text-align="left" width="90%">
                    Dengan hormat,
                    <br>
                    <br>
                    Dengan ini, kami memberitahukan bahwa Ujian Sidang Sarjana

                    {{$program->name}} FPTK UPI akan dilaksanakan tanggal
                    {{ \Carbon\Carbon::parse($event->event_date)->translatedformat('d F Y')}}.
                    Untuk itu, kami mengundang Bapak untuk membuka Sidang Yudisium tersebut pada pada:
                    <br>
                    <br>
                    <table width="100%">
                        <tbody>
                            <tr>
                                <td text-align="left" valign="top" width="15%">
                                    Hari, Tanggal
                                </td>
                                <td text-align="left" valign="top" width="1%">
                                    :
                                </td>
                                <td text-align="left" width="90%">
                                    {{ \Carbon\Carbon::parse($event->event_date)->translatedformat('d F Y')}}.
                                </td>
                            </tr>

                            <tr>
                                <td text-align="left" valign="top" width="15%">
                                    Waktu
                                </td>
                                <td text-align="left" valign="top" width="1%">
                                    :
                                </td>
                                <td text-align="left" width="90%">
                                    Pukul 07:00-selesai
                                </td>
                            </tr>

                            <tr>
                                <td text-align="left" valign="top" width="9%">
                                    Tempat
                                </td>
                                <td text-align="left" valign="top" width="1%">
                                    :
                                </td>
                                <td text-align="left" width="90%">
                                    Auditorium FPTK
                                </td>
                            </tr>
                            
                        </tbody>
                    </table>
                    <br>
                    Demikian undangan ini, atas perkenan Bapak kami ucapkan terima kasih.
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <div id="bodysurat">
        <table width="100%">
            <tbody>
            <tr>
            <td width="70%"> </td>
            <td width="30%">Bandung,
                @if($letter != null)
                    @if(!is_null($letter))
                        {{ \Carbon\Carbon::parse($letter->date)->translatedformat('d F Y')}}.
                        {{--{{ \Carbon\Carbon::parse($letter->date)->translatedformat('d F Y')}} <br />--}}
                    @endif
                    <br>
                    Ketua Program Studi, <br /><br />
                    
                    <img src="{{ public_path().'/images/'.$program->staff->code.'.png'}}" width="100" height="100"/>
                    <br>
                    <br>
                    {{$program->staff->front_title}}
                    {{$program->staff->first_name}}
                    {{$program->staff->last_name}}.
                    {{$program->staff->rear_title}}
                    <br>
                    NIP: {{$program->staff->employee_id}}
                @endif
            </td>
            </tr>
            </tbody>
        </table>
    </div>
   
</body>
</html>
