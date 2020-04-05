Wtyczka "Odblokuj pliki" dla Far Manager 3.0
*****************************************

Wtyczka pozwala si³owo (brutalnie) zamkn¹æ pliku i foldery
(tak¿e z podfolderami) u¿ywane przez inne aplikacje.

Ograniczenia:
  1. Pliki-modu³y (biblioteki dll), za³adowane aplikacje przez wywo³anie
     LoadLibrary dostêpne tylko do odczytu nie mog¹ byæ si³owo zamykane.
  2. Far powinien byæ uruchomiony z prawami u¿ytkownika nie mniejszymi ni¿
     proces otwieraj¹cy plik. Na przyk³ad: je¿eli plik by³ otwarty przez
     administratora, a wtyczka wywo³ana przez zwyk³ego u¿ytkownika to uchwyt
     do pliku nie zostanie odnaleziony.
  3. Nie mo¿na œledziæ plików u¿ywanych przez us³ugi systemowe lub sterowniki.
  4. System operacyjny: MS Windows Vista/7 lub MS Windows Server 2008 lub nowsze.

Znane b³êdy:
  Po u¿yciu tej wtyczki program FAR mo¿e "zawiesiæ siê" przy wyjœciu.

Instalacja:
  Rozpakuj archiwum w folderze wtyczek Far (...Far\Plugins).

Uwaga:
  Wtyczka jest udostêpniana "jak jest" (bez gwarancji). Autor nie odpowiada za konsekwencje
  wynikaj¹ce z u¿ywania tego programu.

Artem Senichev (artemsen@gmail.com)
               https://sourceforge.net/projects/farplugs/
