.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0
FWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
file_in: .ascii "in.txt\0"   # Plik z którego odczytany zostanie ciąg wejściowy
file_out: .ascii "out.txt\0" # Plik do którego zostanie zapisany wynik
 
.bss
.comm in, 1024   # Bufor zawierający znaki (cyfry hex) odczytane z pliku
.comm value, 528 # Bufor zawierający wartości kolejnych bajtów odczytanej
                 # liczby. Jego rozmiar jest spowodowany konwersji systemów
                 # korzystając z właściwości baz skojarzonych. Wspólną
                 # wielokrotnością 4 (ilość bitów które koduje jedna
                 # cyfra heksadecymalna) i 3 (-||- w systemie ósemkowym).
.comm out, 1409  # Bufor wyjściowy zawierający znaki ósemkowe po konwersji.
                 # Rozmiar jest większy o jeden z uwagi na znak końca linii.
 
.text
.globl main # Dla debugowania
 
main:
# WYZEROWANIE BUFORA WARTOŚCI
mov $528, %r8 # Licznik dla pętli zerującej
mov $0, %al   # Wartość wstawiana do bufora
 
petla1:
dec %r8
mov %al, value(, %r8, 1) # Zapisywanie wartości 0 (z AL) do bufora
 
cmp $0, %r8 # Powrót do petla1 jeśli licznik > 0
jg petla1
 
 
 
# WCZYTANIE PIERWSZEGO CIĄGU
# Otwarcie pliku $file_in do odczytu
mov $SYSOPEN, %rax
mov $file_in, %rdi
mov $FREAD, %rsi
mov $0, %rdx
syscall
mov %rax, %r10 # Przepisanie identyfikatora otwartego pliku do R10
 
# Odczyt z pliku do bufora
mov $SYSREAD, %rax
#mov $STDIN, %rdi
mov %r10, %rdi
mov $in, %rsi
mov $1024, %rdx
syscall
mov %rax, %r8 # Zapisanie ilości odczytanych bajtów do rejestru R8
 
# Zamknięcie pliku
mov $SYSCLOSE, %rax
mov %r10, %rdi
mov $0, %rsi
mov $0, %rdx
syscall
 
# DEKODOWANIE JEGO WARTOŚCI W PĘTLI
dec %r8       # Pomijamy znak końca linii
mov $528, %r9 # Licznik do pętli. Liczymy od końca, aby dekodowane
              # wartości dopisywać od na koniec bufora.
 
petla2:
dec %r8
dec %r9
 
# DEKODOWANIE PIERWSZYCH 4 BITÓW
mov in(, %r8, 1), %al
 
# Wybór odpowiedniej sytuacji poniżej
cmp $'A', %al
jge litera
 
# Jeśli cyfra < A
sub $'0', %al
jmp powrot_do_petli2_1
 
# Jeśli cyfra >= A
litera:
sub $55, %al
 
# Powrót do pętli po odjęciu kodu '0' lub 'A'
# aby uzyskać wartość cyfry z jej kodu ASCII.
powrot_do_petli2_1:
 
# Wyskok z pętli jeśli zdekodowano ostatnią cyfrę z bufora in
cmp $0, %r8
jle powrot_do_petli2_3
 
# DEKODOWANIE KOLEJNYCH 4 BITÓW
mov %al, %bl
dec %r8
mov in(, %r8, 1), %al
 
cmp $'A', %al
jge litera2
 
sub $'0', %al
jmp powrot_do_petli2_2
 
litera2:
sub $55, %al
 
powrot_do_petli2_2:
# Pomnożenie wartości zdekodowanej cyfry przez 16 (drugiej części
# bajtu) i dodanie jej do obecnej liczby w buforze.
mov $16, %cl
mul %cl
add %bl, %al
 
# Zapisanie zdekodowanego bajtu do nowego bufora
powrot_do_petli2_3:
mov %al, value(, %r9, 1)
 
# Powrót na początek pętli, aż do zdekodowania całego ciągu
cmp $0, %r8
jg petla2
 
 
 
# KONWERSJA NA SYSTEM ÓSEMKOWY I ZAPIS DO ASCII
mov $527, %r8  # Licznik bajtów z bufora value
mov $1407, %r9 # Licznik znaków ósemkowych z bufora out
 
petla3:
# Odczyt kolejnych bajtów i przesunięcia bitowe,
# aby pobrać z bufora value, do rejestru RAX
# 3 kolejne bajty we właściwej kolejności.
mov $0, %rax
sub $2, %r8
mov value(, %r8, 1), %al
shl $8, %rax
inc %r8
mov value(, %r8, 1), %al
shl $8, %rax
inc %r8
mov value(, %r8, 1), %al
sub $3, %r8
 
mov $8, %r10 # Licznik dla zagnieżdżonej pętli w której nastąpi
             # odczyt 8 znaków ósemkowych z 3 bajtowej liczby.
 
petla4:
mov %al, %bl  # Skopiowanie pierwszego bajtu liczby do rejestru BL
and $7, %bl   # Usunięcie wszystkich bitów poza trzema najmniej znaczącymi
add $'0', %bl # Dodanie kodu znaku ASCII '0' do wyniku maskowania
mov %bl, out(, %r9, 1) # Zapis znaku ASCII do bufora wyjściowego
 
shr $3, %rax # Przesunięcie bitowe dotychczasowej liczby o 3 bity w prawo,
             # tak aby pozbyć się już zdekodowanych 3 bitów.
dec %r9      # Zmniejszenie liczników pętli
dec %r10
cmp $0, %r10 # Skok na początek zagnieżdżonej pętli,
             # jeśli pozostały jeszcze bity liczby do zdekodowania
jg petla4
 
cmp $0, %r8  # Skok na początek petla3, aby pobrać kolejne
jg petla3    # 3 bajty cyfry do dekodowania.
 
 
 
# ZAPISANIE WYNIKU
# Otwarcie pliku $file_out do zapisu.
# Jeśli plik nie istnieje, utworzenie go z prawami 644.
mov $SYSOPEN, %rax
mov $file_out, %rdi
mov $FWRITE, %rsi
mov $0644, %rdx
syscall
mov %rax, %r8
 
# Zapis bufora out do pliku
movq $1408, %r9
movb $0x0A, out(, %r9, 1)
mov $SYSWRITE, %rax
#mov $STDOUT, %rdi
mov %r8, %rdi
mov $out, %rsi
mov $1409, %rdx
syscall
 
# Zamknięcie pliku
mov $SYSCLOSE, %rax
mov %r8, %rdi
mov $0, %rsi
mov $0, %rdx
syscall
 
# ZWROT WARTOŚCI EXIT_SUCCESS
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall