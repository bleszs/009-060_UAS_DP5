    program TokoBuku;
    uses crt, sysutils, dateutils;

    const
        maks_buku = 5;
        username_valid = 'bang tian';
        password_valid = 'kece';

    type
        data_buku = record
            kode_buku, nama_buku: string;
            harga_jual: real;
        end;
        buku = array[1..maks_buku] of data_buku;

    var
        book: buku;
        jumlah_buku: array[1..maks_buku] of integer;
        pilihan: string;
        total_bayar, uang_dibayar, kembalian: real;
        username_input, password_input: string;
        login_berhasil: boolean;
        i: integer;
        
    // ----------------------------PROCEDURE TAMPIL TANGGAL----------------------------
    function get_tanggal: string;
    var
        tahun, bulan, hari: Word;
    begin
        DecodeDate(Date, tahun, bulan, hari);
        get_tanggal := Format('%d/%d/%d', [hari, bulan, tahun]);
    end;

    // ----------------------------PROCEDURE MENAMPILKAN STRUK-----------------------
    procedure tampil_struk(book: buku; jumlah_buku: array of integer; var total_bayar: real);
    var
        i: integer;
    begin
        textbackground(black);
        textcolor(white);
        clrscr;
        writeln('Struk Pembelian Buku:');
        writeln('Tanggal Pembelian: ', get_tanggal());
        writeln('---------------------------------------------');
        writeln('|   Nama Buku     | Jumlah  | Subtotal (Rp) |');
        writeln('---------------------------------------------');
        total_bayar := 0;
        for i := 1 to maks_buku do
        begin
            if jumlah_buku[i] > 0 then
            begin
                writeln('| ', book[i].nama_buku:15, ' | ', jumlah_buku[i]:6, ' | ', (jumlah_buku[i] * book[i].harga_jual):14:0, ' |');
                total_bayar := total_bayar + (jumlah_buku[i] * book[i].harga_jual);
            end;
        end;
        writeln('---------------------------------------------');
        writeln('Total Bayar: Rp.', total_bayar:0:0);
    end;

    // ----------------------------PROCEDURE LOGIN-----------------------------------
    procedure login(var login_berhasil: boolean);
    var
        percobaan: integer;
    begin
        percobaan := 0;
        repeat
            clrscr;
            textcolor(white);
            writeln('====Login dulu brok===');
            textcolor(lightgreen);
            write('Username: '); readln(username_input);
            write('Password: '); readln(password_input);

            if (username_input = username_valid) and (password_input = password_valid) then
            begin
                login_berhasil := True;
                writeln('Login Berhasil! Tekan Enter untuk melanjutkan...');
                readln;
            end
            else
            begin
                textcolor(lightred);
                clrscr;
                writeln('Login Gagal! Username atau Password salah.');
                percobaan := percobaan + 1;
                writeln('Percobaan: ', percobaan, '/3');
                readln;
            end;
        until login_berhasil or (percobaan = 3);

        if not login_berhasil then
        begin
            textcolor(lightred);
            clrscr;
            writeln('Anda telah gagal login sebanyak 3 kali. Program keluar.');
            halt;
        end;
    end;

    // ----------------------------PROCEDURE INISIALISASI DATA------------------------
    procedure inisialisasi_data(var book: buku);
    begin
        book[1].kode_buku := 'FSK01'; book[1].nama_buku := 'Fisika'; book[1].harga_jual := 75000;
        book[2].kode_buku := 'KIM02'; book[2].nama_buku := 'Kimia'; book[2].harga_jual := 80000;
        book[3].kode_buku := 'BIG03'; book[3].nama_buku := 'Biologi'; book[3].harga_jual := 70000;
        book[4].kode_buku := 'MTK04'; book[4].nama_buku := 'Matematika'; book[4].harga_jual := 85000;
    end;

    // ----------------------------PROCEDURE MENAMPILKAN BUKU------------------------
    procedure tampil_buku(book: buku);
    var
        i: integer;
    begin
        clrscr;
        textcolor(white);
        writeln('       Daftar Buku Yang Tersedia       ');
        textbackground(lightblue);
        writeln('--------------------------------------------');
        writeln('|Kode Buku |     Nama Buku    | Harga (Rp)| ');
        writeln('--------------------------------------------');
        for i := 1 to maks_buku do
        begin
            writeln('| ', book[i].kode_buku:8, ' | ', book[i].nama_buku:16, ' | ', book[i].harga_jual:10:0, ' |');
        end;
        writeln('--------------------------------------------');
    end;

    // ----------------------------PROCEDURE MEMILIH BUKU---------------------------
    procedure pilih_buku(var jumlah_buku: array of integer; book: buku);
    var
        kode_input: string;
        i, jumlah: integer;
        found: boolean;
    begin
        textbackground(black);
        textcolor(lightgreen);
        writeln('Masukkan Kode Buku Yang Ingin Dibeli (Ketik "0" untuk selesai):');
        repeat
            textcolor(white);
            write('Kode Buku: '); readln(kode_input);
            if kode_input = '0' then break;
            found := False;
            for i := 1 to maks_buku do
            begin
                if (kode_input = book[i].kode_buku) then
                begin
                    found := True;
                    textcolor(white);
                    write('Jumlah Buku ', book[i].nama_buku, ': '); readln(jumlah);
                    jumlah_buku[i] := jumlah_buku[i] + jumlah;
                    break;
                end;
            end;
            if not found then
                writeln('Kode Buku Tidak Ditemukan, Silakan Coba Lagi!');
        until kode_input = '0';
    end;

    // ----------------------------PROCEDURE MENGURANGI BUKU-----------------------
    procedure kurangi_buku(var book: buku; var jumlah_buku: array of integer; var total_bayar: real);
    var
        kode_input: string;
        i, jumlah_kurang: integer;
        found: boolean;
    begin
        clrscr;
        textcolor(lightred);
        writeln('PERHATIAN: Uang Anda Tidak Mencukupi!');
        textcolor(white);
        writeln('Silakan kurangi jumlah buku untuk menurunkan total harga.');
        
        tampil_struk(book, jumlah_buku, total_bayar);
        
        repeat
            textcolor(lightgreen);
            writeln('Masukkan Kode Buku Yang Ingin Dikurangi (Ketik "0" untuk selesai):');
            textcolor(white);
            write('Kode Buku: '); readln(kode_input);
            
            if kode_input = '0' then break;
            
            found := False;
            for i := 1 to maks_buku do
            begin
                if (kode_input = book[i].kode_buku) and (jumlah_buku[i] > 0) then
                begin
                    found := True;
                    write('Berapa buku ', book[i].nama_buku, ' yang ingin dikurangi? '); 
                    readln(jumlah_kurang);
                    
                    if jumlah_kurang > jumlah_buku[i] then
                    begin
                        textcolor(lightred);
                        writeln('Jumlah pengurangan melebihi jumlah buku yang dibeli!');
                        textcolor(white);
                    end
                    else
                    begin
                        jumlah_buku[i] := jumlah_buku[i] - jumlah_kurang;
                        total_bayar := total_bayar - (jumlah_kurang * book[i].harga_jual);
                        break;
                    end;
                end;
            end;
            
            if not found then
            begin
                textcolor(lightred);
                writeln('Kode Buku Tidak Ditemukan atau Sudah Kosong!');
                textcolor(white);
            end;
            tampil_struk(book, jumlah_buku, total_bayar);
        until false;
    end;

    // ----------------------------PROGRAM UTAMA-------------------------------------
    begin
        login_berhasil := False;
        login(login_berhasil);

        inisialisasi_data(book);
        
        for i := 1 to maks_buku do
            jumlah_buku[i] := 0;

        repeat
            tampil_buku(book);
            pilih_buku(jumlah_buku, book);
            tampil_struk(book, jumlah_buku, total_bayar);

            write('Apakah Anda Ada Tambahan Lagi? (Ya/Tidak): ');
            readln(pilihan);
        until (pilihan = 'Tidak') or (pilihan = 'T') or (pilihan = 't') or (pilihan = 'tidak');

        repeat
            textcolor(white);
            write('Masukkan Uang Pembayaran: Rp.'); 
            readln(uang_dibayar);
            
            if uang_dibayar < total_bayar then
            begin
                textcolor(red);    
                writeln('Uang pun kurang!');
                writeln('Pilih Opsi:');
                writeln('1. Kurangi Jumlah Buku');
                writeln('2. Batalkan Transaksi');
                write('Masukkan Pilihan (1/2): ');
                readln(pilihan);

                case pilihan of
                    '1': begin
                        kurangi_buku(book, jumlah_buku, total_bayar);
                        tampil_struk(book, jumlah_buku, total_bayar);
                    end;
                    '2': begin
                        textcolor(yellow);
                        writeln('Transaksi Dibatalkan.');
                        halt;
                    end
                    else
                        writeln('Pilihan tidak valid!');
                end;
            end;
        until uang_dibayar >= total_bayar;

        kembalian := uang_dibayar - total_bayar;
        textcolor(green);
        writeln('Kembalian Anda: Rp.', kembalian:0:0);
    end.