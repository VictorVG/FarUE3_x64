Wtyczka "Odblokuj pliki" dla Far Manager 3.0
*****************************************

Wtyczka pozwala si�owo (brutalnie) zamkn�� pliku i foldery
(tak�e z podfolderami) u�ywane przez inne aplikacje.

Ograniczenia:
  1. Pliki-modu�y (biblioteki dll), za�adowane aplikacje przez wywo�anie
     LoadLibrary dost�pne tylko do odczytu nie mog� by� si�owo zamykane.
  2. Far powinien by� uruchomiony z prawami u�ytkownika nie mniejszymi ni�
     proces otwieraj�cy plik. Na przyk�ad: je�eli plik by� otwarty przez
     administratora, a wtyczka wywo�ana przez zwyk�ego u�ytkownika to uchwyt
     do pliku nie zostanie odnaleziony.
  3. Nie mo�na �ledzi� plik�w u�ywanych przez us�ugi systemowe lub sterowniki.
  4. System operacyjny: MS Windows Vista/7 lub MS Windows Server 2008 lub nowsze.

Znane b��dy:
  Po u�yciu tej wtyczki program FAR mo�e "zawiesi� si�" przy wyj�ciu.

Instalacja:
  Rozpakuj archiwum w folderze wtyczek Far (...Far\Plugins).

Uwaga:
  Wtyczka jest udost�pniana "jak jest" (bez gwarancji). Autor nie odpowiada za konsekwencje
  wynikaj�ce z u�ywania tego programu.

Artem Senichev (artemsen@gmail.com)
               https://sourceforge.net/projects/farplugs/
