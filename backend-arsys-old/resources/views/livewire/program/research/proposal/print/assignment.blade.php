<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Jadwal</title>

    <style type="text/css">
#tablejadwal {
  font-family: "Times New Roman", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
  margin: 25px 25px 25px 25px;
  color:#444
}

hr {
    display: block;
    height: 2px;
    border: 0;
    border-top: 1px solid #444;
    margin: 1em 0;
    padding: 0px 25px 0px 25px;
    color:#444
}

#kop {
  width: 100%;
  margin: 10px 25px 0px 25px;
  font-size: 20px;
  vertical-align: top;
  color:#666
}


#tablejadwal td, #tablejadwal th {
  border: 1px solid #666;
  padding: 4px;
  vertical-align: top;
  color:#444
}

#bodysurat {
  font-family: "Times New Roman", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 87%;
  margin: 10px 50px 0px 50px;
  font-size: 13px;
  color:#444
}

#tablejadwal th {
  padding-top: 5px;
  padding-bottom: 5px;
  text-align: left;
  background-color: #ddd;
  color:#444
}

        .page-break {
            page-break-after: always;
        }
        @page {
            margin: 0px;
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

    </style>

</head>
<body>

    @php(\Carbon\Carbon::setLocale('id'))
    @php($counter = 0)
    @foreach ($research->supervisor as $index => $supervisor)
        <div id="kop">
            <table width="100%">
                <tbody>
                    <tr>
                        <td align="right" style="width: 18%">
                        <img src="{{ public_path().'/images/upi.png'}}" width="80" height="80"/>
                        </td>
                        <td align="right" style="width: 2%">
                        </td>

                        <td align="left" style="width: 80%">
                            <b>KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET, DAN TEKNOLOGI <br />
                                    UNIVERSITAS PENDIDIKAN INDONESIA <br />
                                    FAKULTAS PENDIDIKAN TEKNOLOGI DAN KEJURUAN <br /></b>
                            Jl. Dr. Setiabudi No. 207 Bandung 40154 
                            <br>
                            Telp. (022) 2011576 Ext. 34001 s.d 34008, 34017 Fax (022) 2011576
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <hr>
        <div id="bodysurat">
            <table width="100%">
                <tbody>
                    <tr>
                        <td align="center"><b>SURAT TUGAS</b><br />
                        No: 
                    </td>
                    </tr>
                
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="text-align: justify">
                            Memperhatikan Surat Ketua Prodi Teknik Elektro FPTK–UPI 
                            Nomor :151/UN40.F5.9/PK/2021 tentang usulan Penunjukkan Dosen 
                            Pembimbing Sripsi, Dekan FPTK UPI menugaskan kepada:
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="bodysurat">
            <table width="100%">
                <tbody>
                    <tr>
                        <td width="20%">Nama</td>
                        <td text-align="left">: 
                            {{$supervisor->staff->front_title}}
                            {{$supervisor->staff->first_name}}
                            {{$supervisor->staff->last_name}}
                            {{$supervisor->staff->rear_title}}
                        </td>
                    </tr>

                    <tr>
                        <td width="20%">NIP</td>
                        <td text-align="left">: 
                            {{$supervisor->staff->employee_id}}
                        </td>
                    </tr>

                    <tr>
                        <td width="20%">Pangkat, Golongan</td>
                        <td text-align="left">: 
                        </td>
                    </tr>
                    <tr>
                        <td width="20%">Jabatan</td>
                        <td text-align="left">: 
                        </td>
                    </tr>
                    <tr>
                        <td width="20%">Program studi</td>
                        <td text-align="left">: 
                            {{$supervisor->staff->program->name}}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="bodysurat">
            <table width="100%">
                <tbody>
                    <tr>
                        <td>
                            Sebagai Pembimbing&nbsp;
                            @if($counter == 0)
                                I (satu) 
                            @else
                                II (dua)
                            @endif
                            &nbsp;dalam Penulisan Skripsi untuk Mahasiswa : 
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="bodysurat">
            <table width="100%">
                <tbody>
                    <tr>
                        <td width="20%">Nama</td>
                        <td text-align="left">: 
                            {{$research->student->first_name}} {{$research->student->last_name}}
                        </td>
                    </tr>
                    <tr>
                        <td width="20%">NIM</td>
                        <td text-align="left">: 
                            {{$research->student->program->code}}.{{$research->student->number}}
                        </td>
                    </tr>
                    <tr>
                        <td width="20%">Program studi</td>
                        <td text-align="left">: 
                            {{$research->student->program->name}} - 
                            {{$research->student->program->level->code}}
                        </td>
                    </tr>
                    <tr>
                        <td width="20%"><b>Dengan judul</b></td>
                        <td text-align="left">: 
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div id="bodysurat">
            <table width="100%">
                <tbody>
                    
                    <tr>
                        <td style="text-align: justify">
                            <b>
                                {{$research->title}} 
                            </b>
                        </td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td style="text-align: justify">
                            Surat tugas ini dibuat untuk dilaksanakan dengan penuh tanggung jawab 
                            dan berlaku terhitung mulai tanggal dikeluarkannya sampai (30 Desember 2021).
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        @if($index < 1)
            <div class="page-break"></div>
        @endif
        @php($counter++)
    @endforeach
</body>
</html>
