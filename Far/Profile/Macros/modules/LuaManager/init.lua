local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info {
  name          = "LuaManager";
  description   = "Менеджер Lua/Moon-скриптов для Fara";
  version       = "5.2.0"; --в формате semver: http://semver.org/lang/ru/
  author        = "IgorZ";
  url           = "http://forum.farmanager.com/viewtopic.php?t=7936";
  id            = "180EE412-CBDE-40C7-9AE6-37FC64673CBD";
  minfarversion = {3,0,0,5210,0}; --при несоответствии скрипт завершится
  files         = [[.\English.hlf;.\Russian.hlf;.\English.lng;.\Russian.lng;.\templates]]; --вспомогательные файлы скрипта
  helptxt       = [[
Вызов:
  - require"LuaManager"([<таблица параметров>]) или require"LuaManager".Main([<таблица параметров>]). Главное меню. Поля таблицы:
    - MaSort,EvSort,MoSort,MISort,PrSort,PMSort - сортировка макросов, обработчиков событий, модулей, пунктов меню плагинов,
        префиксов командной строки и панельных модулей;
        значение - строка букв, можно посмотреть в языковых файлах в cbXXXSortVariants; заглавная/строчная буква - сортировка по возрастанию/убыванию.
    - AFilter,KFilter,GFilter,PFilter,FFilter,SFilter - фильтр областей, клавиш, групп, путей поиска модулей, файлов со скриптами, пакетов скриптов.
    - MaShow,KMShow,EvShow,MoShow,MIShow,PrShow,PMShow,AMShow - показывать стационарные/клавиатурные макросы/обработчики событий/модули/
        пункты меню плагинов/префиксы командной строки/панельные модули/макросы из неактивных областей.
    - ResetFilters -- если истина, то перед применением параметров включить показ всего и сбросить все фильтры.
    Значения пропущенных полей берутся из конфигурации скрипта.
  - require"LuaManager".Config(). Настройка параметров.
  - require"LuaManager".InsertScript([<тип скрипта>]). Вставить скрипт в текущий открытый на редактирование файл. Тип скрипта:
      1 - макрос, 2 - обработчик событий, 3 - пункт меню плагинов, 4 - префикс командной строки, 5 - панельный модуль, иначе запрашивается.
  - require"LuaManager".EditScript([<строка>]). Редактировать скрипт из текущего открытого на редактирование файла. Строка:
      если указана, редактируется скрипт, в который входит строка с указанным номером, иначе предлагается выбор из всех в файле.
  - require"LuaManager".InsUid(). Вставка сгенерированного uid в позиции курсора.
  - require"LuaManager".Reload(<OnNotSaved>). Перезагрузка скриптов. OnNotSaved:
      если текущая область - редактор с несохранённым файлом, то выбор действия:
      "save" - сохранить и перезагрузить, "ignore" - перезагрузить без сохранения, "cancel" - ничего не делать, иначе - спросить.
]];
  history       = [[
2013/04/25 v1.0   - Первый релиз
2013/04/25 v1.0.1 - Мелкие правки: убрал сообщение об отказе от редактирования, сделал компактный вывод областей макросов.
                    Пока в функции ShortArea оставил все три возможных варианта: по 2 буквы и 2 варианта по 1-й (2 закомментированы), на пробу.
                    Позже оставлю 1 лучший (высказывания по поводу приветствуются).
2013/04/29 v1.0.2 - Настройка максимальной ширины для клавиш и описаний; показ файловых масок для обработчиков событий, окружения
                    для condition/action.
2013/04/30 v1.0.3 - Исправление ошибок, оптимизация,фильтры областей и групп, опция открытия файла в редакторе по ALtF4,
                    даже если не смог найти макрос.
2013/08/30 v1.0.4 - Изменение работы с DI_USERCONTROL, поправлена работа с флагами, скрытие/показ макросов для других областей, диалог настроек,
                    хранение настроек в БД, мелкие правки.
2013/09/19 v1.1   - Локализация вынесена в отдельные файлы, мелкие правки.
2013/09/23 v1.2   - Изменён принцип поиска скрипта в файле, мелкие правки и добавления.
2013/09/27 v1.2.1 - Вернул старый принцип работы с DI_USERCONTROL - скрипт снова работает со stable версией,
                    возможность хранить настройки в локальном профиле (раскомментировать нужный SettingsStorage), мелкие правки.
2013/09/30 v1.2.2 - Исправлена ошибка с регистрозависимостью областей и групп, добавлены проверки на отсутствие файла (временные макросы),
                    проверяется string.format("%N.Ns") на N>99, исправление ошибок в просмотре, мелкие правки.
2013/10/07 v1.2.3 - Исправлена ошибка в преобразовании списка областей в короткий вид, сделан фильтр по нажатию клавиши,
                    в просмотре окружения для condition и action разделены, т. к. теоретически могут быть разные.
2013/10/11 v1.3.0 - Переписан алгоритм работы с condition/action. Исправлено множество ошибок. Улучшен поиск Macro/Event - теперь ищется
                    и по condition.
                    Переключение языка в соответствии с настройками Farа при каждом запуске. Коррекция главного меню. Различные мелкие правки.
2013/10/18 v1.3.1 - Сортировка, новый макрос, вставляющий скрипт в редактируемый .lua файл, мелкие исправления. Экспериментально: отсев скриптов,
                    которые нельзя выполнить в данном контексте, с помощью атрибута grayed. Если народ будет против - уберу.
2013/10/18 v1.3.2 - Исправление главного меню, когда описания выводятся некорректно, урезан нижний заголовок, чуть поправлены языковые файлы.
2013/10/24 v1.3.3 - Убрано ограничение на максимальную длину полей в 99 символов, мелкие правки.
2013/12/10 v1.3.4 - Мелкие правки.
2013/12/12 v1.3.5 - Клавиши вызова макросов можно переопределять в диалоге конфигурации.
2014/06/27 v1.3.6 - Изгнание io.lines. Если языка нет, подгружается английский, мелкие правки.
2014/08/06 v1.4.0 - Поддержка .moon. Поддержка LuaExplorer и Rebind от JohnDow. Рефакторинг.
2014/08/08 v1.4.1 - Поддержка uid в диалоге редактирования макросов. Длина поля описания=0 - отключение свёртки строк. Исправление ошибок.
                    Мелкие правки.
2014/08/15 v1.4.2 - Улучшены фильтр клавиш и индикация фильтрации. Вставка .moon (а не .lua) скрипта в редактируемый .moon файл. Рефакторинг.
2014/08/22 v1.4.3 - Перекомпоновка и авторазмер по вертикали диалоговых окон редактирования. Добавлены uid для макросов. Мелкие правки.
2016/02/26 v1.4.4 - При вставке макроса/обработчика событий в редактируемый файл выводится сообщение об ошибке.
2014/11/04 v2.0.0 - Поддержка модулей. Макрос вставки uid, макросы раздельной вставки Macro и Event, вставка менеджера в меню плагинов.
                    В диалогах для редактирования condition/action надо встать в соответствующее поле и нажать F4 или сделать двойной щелчок
                    мышью. При незаполненных обязательных полях делает запрос действия: продолжить или вернуться в режим редактирования.
                    Для пустых condition/action при редактировании вставляет шаблон.
                    Макрос, на котором стоит курсор, запоминается между вызовами. Много рефакторинга, исправление ошибок.
2014/12/29 v2.1.0 - Скрипт можно использовать как модуль. Пример: require"LuaManager"({KFilter=".*F3",EvShow=false,MoShow=false}). Клавиатурные
                    макросы возможно сохранять в новом и в старом формате (по умолчанию - в новом, если версия Far>=4202). При редактировании в
                    диалоге вставляются все поля, а не только отличные от умолчания. Отключённые скрипты помечаются символом DSB, а не забиванием
                    области. Для модулей в списке не выводится имя файла. Добавлена справка в диалог настройки. Добавлено временное
                    отключение/включение модулей. Реализовано с помощью добавления/убирания специального расширения. Исправление ошибок.
2015/01/30 v2.1.1 - Корректно обрабатывается отсутствие модулей "le" и "rebind". Символы для обозначений выбраны из поддерживаемых всеми
                    TrueType шрифтами.
2015/05/29 v2.2.0 - Убрана лишняя проверка при вызове из меню плагинов. У макросов с полем key="none" его значение заменялось на "Ø". Признано
                    перебором и оставлено только для случаев отсутствия поля key. Для новых макросов изначально area не пустая, а Common.
                    Исправлена ошибка, когда в диалоге редактирования не работала клавиша F4, если включена хотя бы одна -Lock клавиша. Поправлены
                    горячие клавиши в диалоге редактирования. Если в скрипте после редактирования в диалоге есть незаполненные обязательные поля,
                    сообщение обо всех выводятся в одном окне, а не по отдельности. При редактировании пустого condition/action, если оставлен
                    изначальный текст шаблона, то восстанавливается пустое значение. При вставке скрипта в текущий файл поля со значениями по
                    умолчанию закомментируются. Вставка скрипта в текущий файл - одно действие Undo/Redo. При вставке скрипта в текущий файл
                    макросы не перезагружаются автоматически. Добавлен макрос перезагрузки скриптов. В списке модулей поддерживаются также и .dll
                    из package.cpath (осторожно! не тестировалось! на свой страх и риск!)
2015/06/17 v2.2.1 - Горячие клавиши и справка в меню фильтров. При вставке макроса/обработчика событий для condition/acrtion по умолчанию
                    вставляется также шаблон. Сделана более корректная настройка скрипта как модуля. В диалоге редактирования макроса горячие
                    клавиши флагов активной/пассивной панели работают, переключая при повторении друг между другом. Найденные модули не грузятся
                    сразу, а подгружаются по запросу (если не загружены). Доделан фильтр файлов со скриптами. Мелкие правки.
2015/06/25 v2.2.2 - Исправление ошибки при пустом списке. Скрипты после редактирования в редакторе перезагружаются только, если изменился файл.
                    В диалоге редактирования макроса горячие клавиши флагов активной/пассивной панели работают, переключая при повторении друг
                    между другом, если задержка между нажатиями меньше указанной в настройках. Мелкие правки.
2015/07/24 v2.2.3 - Если маска файлового фильтра не содержит расширения, то в конце добавляется .lua и .moon. Для флагов активной/пассивной панели
                    горячие клавиши с RAlt срабатывают для флагов пассивной панели, в остальных случаях - для активной. CtrlL в главном меню и
                    диалоге настройки сбрасывает все настройки на сохранённые. Изменены клавиши текущей настройки сортировки скриптов. Переделана
                    справка. Добавлены быстрые клавиши в диалог конфигурации. Мелкие правки.
2015/07/27 v2.2.4 - Исправлена вставка заготовок тел обработчиков событий. Мелкие правки.
2015/02/29 v2.2.5 - Исправлено добавление скриптом себя в модули. Настоятельно рекомендуется хранить скрипт в отдельной папке. Мелкие правки.
2015/07/31 v2.2.6 - Исправлено добавление скриптом себя в модули - теперь должно быть совсем правильно. Убраны ненужные обращения к глобальным
                    переменным. Исправлена ошибка с выполнением макроса после вызова из меню плагинов. Мелкие правки.
2015/08/04 v2.2.7 - Исправлена ошибка с порчей настроек клавиш при редактировании конфигурации. Изменена быстрая клавиша закрытия диалога
                    конфигурации без сохранения параметров в базе. Мелкие правки.
2015/10/08 v2.2.8 - Добавлена поддержка ConsoleInput в редакторе обработчиков событий. Мелкие правки.
2016/02/26 v2.3.0 - Изменён принцип загрузки скрипта как модуля. Улучшена работа с файлами справки. Мелкие правки.
2016/03/09 v2.3.1 - Добавлена обработка параметра sortpriority. Мелкие правки.
2016/05/20 v2.3.2 - Добавлена возможность редактирования в диалоговом окне скрипта под курсором. Смена места хранения данных. Мелкие правки.
2016/06/10 v3.0.0 - Добавлена поддержка MenuItem и CommandLine. Рефакторинг. Разные правки.
2016/06/14 v3.0.1 - Исправлена глупая очепятка в английском языковом файле.
2016/06/17 v3.1.0 - При выводе справки используется язык справки фара. Изменена логика настройки ширины колонок.
                    Изменена логика работы с фильтром клавиш. Рефакторинг. Доработана справка. Мелкие правки.
2016/06/22 v3.1.1 - Добавлена проверка результатов операций файлового ввода-вывода. При вставке скрипта из меню имя файла назначения показывается
                    и редактируется. Экспериментально: изменена идеология диалога настройки сортировки. По AltL загружается комбинация фильтров,
                    активная на момент закрытия LuaManager в прошлый раз. Рефакторинг. Мелкие правки.
2016/06/23 v3.1.2 - При вставке скрипта из меню макросы не перезагружались. Если при вставке скрипта поле имени файла пусто и действие - не
                    отмена, диалог не завершается. Если модуль rebind не установлен, то пустой uid вносится в скрипт как комментарий.
2016/07/01 v3.1.3 - При редактировании скрипта из файла можно выбрать любой из имеющихся. Текущий (если есть) - под курсором в меню. Для Macro и
                    Event uid формируется всегда, независимо от наличия rebind. Добавлена справка по диалогам редактирования. Рефакторинг.
2016/07/06 v3.1.4 - Исправлена ошибка со сбросом к старым значениям фильтра после сохранения конфигурации. Поправлены хоткеи в диалоге
                    конфигурации. Справка дополнена новыми разделами. В главное меню добавлены команды CtrlA,CtrlShiftK,CtrlAltF. Мелкие правки.
2016/08/04 v3.1.5 - Доработка под поле "id" в Macro/Event для новых версий LuaMacro/rebind. Мелкие правки.
2016/08/09 v3.1.6 - В окне просмотра выводимые значения сортируются по типам и именам и не зацикливаются. Ссылки на таблицы отображаются "->" или
                    "-^" (для рекурсивных). Рефакторинг.
2016/08/12 v3.1.7 - Добавлен модуль-заглушка на случай require"LuaManager" из _macroinit.lua. В параметры, передаваемые модулю, включён
                    ResetFilters: если истина, то перед применением параметров включить показ всего и сбросить все фильтры.
2016/10/27 v3.1.8 - Изменён способ получения версии LuaMacro. Теперь можно редактировать несохранённые клавиатурные макросы.
                    Модуль теперь возвращает таблицу функций (старый вариант вызова сохранён). Изменён способ регистрации модуля.
2017/04/07 v3.1.9 - Немного изменён способ регистрации модуля. Рефакторинг. Разбор описания на подстроки неправильно работал, если у префикса
                    командной строки не указано описание. Исправлена ошибка с фильтром модулей по умолчанию, появившаяся в 3.1.7. Мелкие правки.
2017/05/04 v3.1.10- Мелкие правки, в основном предотвращение ошибок, которых, по идее, не могло случиться.
2017/05/17 v3.1.11- Рефакторинг. Мелкие правки.
2017/05/18 v4.0.0 - Основная логика скрипта вынесена в отдельный модуль. Макрос стал просто обвязкой к нему.
2017/10/25 v4.0.1 - Поддерживаются многострочные описания. Исправлена ошибка с редактированием скрипта из открытого файла.
2017/10/30 v4.0.2 - Добавлены области Grabber и Desktop. Добавлена ограниченная поддержка пакетов скриптов (regscript).
                    Изменена логика работы с многострочными описаниями. Добавлен один режим вывода описаний. Мелкие правки.
2017/11/07 v4.0.3 - При вызове модуля можно указывать поле 'SFilter="<Имя скрипта>"' для фильтрации по всем файлам, входящим в этот пакет скриптов.
                    При просмотре макроса многострочные описания выводятся в несколько строк. Изменения и дополнения в справке. Разные правки.
2017/11/21 v4.0.4 - Опциональное поле имени файла без пути. Доработано сохранение позиции в главном меню.
2018/05/02 v5.0.0 - Добавлена поддержка PanelModule. Шаблоны для диалогов редактирования вынесены в отдельный файл "templates".
                    При чтении параметра из БД и записи в БД производится автозамена переменных окружения FARPROFILE, FARLOCALPROFILE и FARHOME.
                    Более корректное определение номеров строк в .moon файлах. Доработана индикация фильтрации в главном меню.
                    Пункты меню плагинов фильтруются по областям аналогично макросам. В целях единообразия показ/скрытие макросов
                    и пунктов меню плагинов не из текущей области перенесён с CtrlH на AltH. Тотальный рефакторинг.
2018/05/18 v5.0.1 - Шаблон события ExitFar скорректирован в соответствии с изменениями в плагине. Исправлена ошибка с обработкой нажатия кнопки
                    "Панели" в диалоге конфигурации. Ещё всякие мелочи.
2018/11/06 v5.0.2 - Добавлен макрос вставки панельного плагина. Рефакторинг. Мелкие правки.
2018/12/10 v5.0.3 - Добавлена фильтрация по фиктивному/отстутствующему key. Доработана поддержка несохранённых клавиатурных макросов.
2019/09/11 v5.0.4 - Исправлена редкая ошибка, когда LuaManager по какой-то причине не мог правильно определить текст скрипта и зацикливался.
                    Исправлена ошибка с обращением к Description при редактировании панельного модуля. Исправлена функция сохранения одного параметра.
                    Исправлена ошибка с лишним "%" в новом значении в gsub.
2019/11/08 v5.0.5 - Исправлена ошибка с :match со слишком большим количеством строк в шаблоне. Небольшой рефакторинг.
2019/11/22 v5.0.6 - Исправлена ошибка, возникающая после редактировании модуля вида ?\init.lua.
2020/05/15 v5.1.0 - Убрана совместимость с очень старыми версиями Far. Исправлена ошибка с редактированием нового панельного модуля в диалоге.
                    Улучшена замена фрагмента. Обрезаем лишние BOM. Рефакторинг.
2020/05/18 v5.1.1 - Поправлено обрезание BOM.
2021/05/11 v5.1.2 - Исправлена ошибка с MaxDescWidth и MacroMaxDescWidth. Оптимизирована сортировка элементов.
2021/06/25 v5.1.3 - Исправлена ошибка с русскими описаниями в файлах скриптов в кодировке Windows.
2021/06/28 v5.1.4 - Исправлена ошибка с загрузкой параметров, если БД пустая.
2021/08/16 v5.1.5 - Исправлена корректировка значения комбобокса для обхода ошибки возникшей из-за 5859.2.
2021/09/01 v5.2.0 - Добавлена настройка порядка вывода разных типов скриптов. Данные макросов убраны из модуля. Рефакторинг. Исправление ошибок.
]];
  options       = {
    DefProfile = far.Flags.PSL_ROAMING--[[far.Flags.PSL_LOCAL--]] -- место хранения настроек по умолчанию: глобальные/локальные
  }
}
if not nfo then return nfo end
-- +
--[==[Константы]==]
-- -
local F,Author,ConfPart = far.Flags,"IgorZ","LuaManager"
local Guids = {
  Sort = win.Uuid("2F4306C4-E0FA-487C-BB81-19D579CDF757"), -- уникальный guid диалога сортировки
  MacroEdit = win.Uuid("9BED5980-6563-4DDA-B5CA-314F93E4EB1B"), -- уникальный guid диалога редактирования макроса
  KeyMacroEdit = win.Uuid("E575E6A9-89DA-4540-B929-223AF97732BD"), -- уникальный guid диалога редактирования клавиатурного макроса
  EventEdit = win.Uuid("56510B51-CE7C-4BE9-A4C8-5D905931D099"), -- уникальный guid для диалога редактирования обработчика событий
  PrefixEdit = win.Uuid("E857EB9E-6B95-4998-A933-519C1843A540"), -- уникальный guid диалога редактирования префикса командной строки
  PanelEdit = win.Uuid("0D6A7B6C-0C3C-42A0-8EED-F189CE12BAB4"), -- уникальный guid диалога редактирования панельного модуля
  Config = win.Uuid("6C72E763-62EF-47C9-A37A-94CEC63853AE"), -- уникальный guid диалога конфигурации
  Rebind = win.Uuid("FA0EA667-6C9E-4F41-92E9-E55C96B03E16"), -- уникальный guid диалога переназначения клавиш
  CreateNew = win.Uuid("8ADA595D-A1CB-497B-B40E-BD0CB5EB956B"), -- уникальный guid диалога вставки нового скрипта
  Menu = win.Uuid("6B19D0FA-7C8C-4289-8CFE-4CD5914F787D"), -- уникальный guid главного меню
}
local Path = debug.getinfo(1).source:match("^@?([^@].*\\)[^\\]*$") -- путь к модулю
local Areas = {[0]="Other","Shell","Viewer","Editor","Dialog","Search","Disks","MainMenu","Menu","Help","Info","QView","Tree","FindFolder",
                   "UserMenu","ShellAutoCompletion","DialogAutoCompletion","Grabber","Desktop",common="Common"}
local AreasCount = #Areas+2 -- Areas[0] и Areas.common не считает
local AreasRev = {} for n,v in pairs(Areas) do AreasRev[v:lower()] = n end -- для быстрого получения номера области по её имени
local FH,GP,LP,MM = win.GetEnv("FARHOME"),win.GetEnv("FARPROFILE"),win.GetEnv("FARLOCALPROFILE"),[[\Macros\modules\]] -- профиля, путь к модулям
local OffExt,DSB,NoKey,Noid,RBN,CNT,UP,LO = ".Switched_off","×","Ø","<no id>","≈","»","↑","↓" -- расширение отключения, разные признаки
local FuncNames = {"Analyse","ClosePanel","Compare","DeleteFiles","GetFiles","GetFindData","GetOpenPanelInfo","MakeDirectory","Open",
                   "ProcessHostFile","ProcessPanelEvent","ProcessPanelInput","PutFiles","SetDirectory","SetFindList"}
-- Шаблоны для диалогов редактирования
local Templates = (loadfile(Path.."templates") or function() return setmetatable({},
  {__index=function(t,i) for _,fn in ipairs(FuncNames) do if i==fn then i = "!" break end end return i:len()==1 and "" or t end}) end)()
local Def = { -- Настройки по умолчанию
  TableRecursion = true, -- при просмотре переменных разворачивать таблицы
  MaxKeyWidth=0,MaxFileWidth=0,MaxDescWidth=0, -- клавиши выводятся полностью; имена файлов не выводятся; описания выводятся полностью
  MacroSortingOrder="OCAKD",EventSortingOrder="GD",ModuleSortingOrder="TMN",MISortingOrder="A",PrefixSortingOrder="P",PanelSortingOrder="AT",
  AreaFilter="",KeyFilter="",GroupFilter="DialogEvent ViewerEvent EditorEvent EditorInput ConsoleInput ExitFAR", -- фильтры
  PathFilter='"'..GP..MM..'?.lua" "'..GP..MM..'?\\init.lua" "'..GP..MM..'?.moon" "'..GP..MM..'?\\init.moon"',
  ShowMacros=1,ShowKeyMacros=1,ShowEvents=1,ShowModules=1,ShowMenuItems=1,ShowPrefixes=1,ShowPanels=1,ShowNonActiveMacros=1,
  ShowOrder = "MKEOIPN", -- что показывать и в каком порядке
}
for _,a in pairs(Areas) do Def.AreaFilter = (Def.AreaFilter.." "..a):gsub("^ ","") end
local IsEV = regex.new("/(Editor|Viewer)/i") -- проверка области на редактор/просмотрщик
-- доставалка префиксов, пунктов меню плагинов и редактора несохранённых клавиатурок
local MenuItems,Prefixes,PanelModules,EditUnsavedMacro do
  local utils,LoadMacros
  for i=1,debug.getinfo(eval).nups do local k,v = debug.getupvalue(eval,i) if k=="utils" then utils = v break end end
  EditUnsavedMacro = assert(utils.EditUnsavedMacro) LoadMacros = assert(utils.LoadMacros)
  for i=1,debug.getinfo(LoadMacros).nups do local n,v = debug.getupvalue(LoadMacros,i)
    if n=="AddedMenuItems" then MenuItems = v end if n=="AddedPrefixes" then Prefixes = v end if n=="LoadedPanelModules" then PanelModules = v end
  end
end
-- +
--[[переменные]]
-- -
local L,LT,S,LastFilter,UsedProfile -- языковые данные, конфигурация, последний применённый фильтр, используемый профиль
local function _f() return "Cannot find language file" end -- функция возвращает сообщение-затычку
L = setmetatable({},{__index=function(_,idx) -- языковые данные, меняющиеся при смене языка, да ещё с затычкой
  local FL,res = (Far.GetConfig("Language.Main")) -- язык, значение
  if LT and LT.Lang==FL then return LT[idx] end -- язык совпадает - вернём требуемое
  local LF = loadfile(Path..FL..".lng") or loadfile(Path.."English.lng") -- функция, возвращающая языковые данные
  if LF then LT = LF() return LT[idx] else return setmetatable({},{__index=_f,__tostring=_f}) end -- нашли - запомним и вернём, иначе вернём затычку
  end})
-- +
--[==[Подключаемые модули]==]
-- -
local ok_le,le = pcall(require,"le") le = ok_le and le -- LuaExplorer
local rb = package.loaded.rebind -- Rebind, только если загружен из _macroinit.lua
local rs = package.loaded.regscript -- Regscript, только если загружен из _macroinit.lua
-- +
--[==[Вспомогательные функции]==]
-- -
local LoadSettings,SaveSettings,GenUid,MacroKey,MoonLine,PrepareFiles,SetFilter,SortingOrder,FillUserControl,EditFun,CreateAsText,DoIt,
      GetType,ShowHelp,Read,Write,Replace,ErrMess,FMatch
-- +
--[==[Основные функции]==]
-- -
local ShowInfo,OpenMacroInDialog,OpenInternalMacroInDialog,OpenEventInDialog,OpenMenuItemInDialog,OpenPrefixInDialog,OpenPanelModuleInDialog,
  OpenInEditor,CreateNew,DeleteCurrent,Rebind,Disable,Config
-- +
--[==[Главные функции]==]
-- -
local InsertScriptIntoEditor,EditScriptUnderCursor,Reload,ManageMacrosEvents
--------------------------------------------------------------------------------
function LoadSettings(ForceDef) --[[загрузить настройки из БД]]
L.PathItems = {type = "Module"} -- запишем куда надо все пути поиска модулей
for v in (package.path..";"..package.moonpath..";"..package.cpath..";"):gmatch("(.-);") do -- переберём все возможные места расположения
  L.PathItems[#L.PathItems+1] = {text = v} -- допишем очередное
end
UsedProfile = nfo.options.DefProfile -- запомним профиль
local obj = far.CreateSettings(nil,UsedProfile) -- откроем предпочтительные настройки
local key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) -- есть раздел?
if not key then -- настроек нет?
  obj:Free() obj = far.CreateSettings(nil,UsedProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL) -- откроем другие настройки
  key = obj:OpenSubkey(obj:OpenSubkey(0,Author) or 0,ConfPart) -- есть раздел? если нет, неважно, какой открыт, всё равно брать умолчания
  if key then UsedProfile = UsedProfile==F.PSL_LOCAL and F.PSL_ROAMING or F.PSL_LOCAL -- из другого профиля открылись? запомним профиль
  else obj:Free() obj = far.CreateSettings(nil,UsedProfile) key = obj:CreateSubkey(obj:CreateSubkey(0,Author) or 0,ConfPart) end -- создадим пустой
end
local function L1(n) return not ForceDef and obj:Get(key or -1,n,type(Def[n])=="string" and F.FST_STRING or F.FST_QWORD) or Def[n] end
S = { TableRecursion = L1("TableRecursion")~=0, -- считаем настройки
  MaxKeyWidth = L1("MaxKeyWidth"),MaxFileWidth = L1("MaxFileWidth"),MaxDescWidth = L1("MaxDescWidth") or L1("MaxDescWidth"),
  SO = {M=L1("MacroSortingOrder"),E=L1("EventSortingOrder"),O=L1("ModuleSortingOrder"),I=L1("MISortingOrder"),P=L1("PrefixSortingOrder"),
        N=L1("PanelSortingOrder")},
  Filter = {K=L1("KeyFilter"),A=L1("AreaFilter"),G=L1("GroupFilter"),P=L1("PathFilter"):gsub("%%(.-)%%",win.GetEnv),F="*"},
  Show = {M=L1("ShowMacros")~=0,K=L1("ShowKeyMacros")~=0,E=L1("ShowEvents")~=0,O=L1("ShowModules")~=0,I=L1("ShowMenuItems")~=0,
          P=L1("ShowPrefixes")~=0,N=L1("ShowPanels")~=0,H=L1("ShowNonActiveMacros")~=0,Order=L1("ShowOrder")}}
obj:Free() -- приберёмся
S.SavedFilter = {A=S.Filter.A,G=S.Filter.G,P=S.Filter.P,K=S.Filter.K,F=S.Filter.F}
end
--
function SaveSettings() --[[сохранить настройки в БД]]
if UsedProfile==F.PSL_LOCAL then win.CreateDir(LP.."\\PluginsData") end -- создадим папку для локальных настроек (если надо)
local obj = far.CreateSettings(nil,UsedProfile) -- откроем ранее прочитанные или предпочтительные настройки
local key = obj:CreateSubkey(obj:CreateSubkey(0,Author),ConfPart) -- откроем/создадим раздел
local function S1(n,v) if v==nil then v=S[n] end; if v==nil then obj:Delete(key,n) else local w,t = v==true and 1 or v or 0,
                       type(v)=="string" and F.FST_STRING or F.FST_QWORD; if obj:Get(key,n,t)~=w then obj:Set(key,n,t,w) end end end
S1("TableRecursion") S1("MaxKeyWidth") S1("MaxFileWidth") S1("MaxDescWidth") S1("MacroSortingOrder",S.SO.M)
S1("EventSortingOrder",S.SO.E) S1("ModuleSortingOrder",S.SO.O) S1("MISortingOrder",S.SO.I) S1("PrefixSortingOrder",S.SO.P)
S1("PanelSortingOrder",S.SO.N) S1("KeyFilter",S.Filter.K) S1("AreaFilter",S.Filter.A) S1("GroupFilter",S.Filter.G)
S1("PathFilter",S.Filter.P:gsub(GP,"%%FarProfile%%"):gsub(LP,"%%FarLocalProfile%%"):gsub(FH,"%%FarHome%%"))
S1("ShowMacros",S.Show.M) S1("ShowKeyMacros",S.Show.K) S1("ShowEvents",S.Show.E) S1("ShowModules",S.Show.O) S1("ShowMenuItems",S.Show.I)
S1("ShowPrefixes",S.Show.P) S1("ShowPanels",S.Show.N) S1("ShowNonActiveMacros",S.Show.H) S1("ShowOrder",S.Show.Order)
obj:Free() -- приберёмся
S.SavedFilter = {A=S.Filter.A,G=S.Filter.G,P=S.Filter.P,K=S.Filter.K,F=S.Filter.F} -- запомним для сбрасывания к ним
end
--
function GenUid() return win.Uuid(win.Uuid()):upper() end --[[генерировать новый uid]]
--
function MacroKey(hDlg) --[[ввод клавиши в диалоге]]
far.Message(L.PressKey,"","") far.Text() local VK=mf.waitkey() if hDlg then hDlg:send(F.DM_REDRAW) end return VK
end
--
local errors,tables,cache
function MoonLine(file,line) --[[получим номер строки в исходном .moon файле!!!работает плохо (нужна поправка на строки-комментарии)!!!]]
if not errors then errors = require"moonscript.errors" end
if not tables then tables = require"moonscript.line_tables" end
if not cache then cache = {} end
return errors.reverse_line_number(file,tables["@"..file],line,cache)
end
--
function PrepareFiles(item) --[[извлечь condition/text, action, тело скрипта]]
-- на выходе таблица
-- t.name,t.body,t.file - имя и тело функции text, файл, её содержащий
-- c.name,c.body,c.file - имя и тело функции condition, файл, её содержащий
-- a.name,a.body,a.file - имя и тело функции action, файл, её содержащий
-- X.name,X.body,X.file - имя и тело функции, файл, её содержащий; имена функций - все по списку
-- stype,smoon,spfx,sbody,sstartx,sstarty - вид скрипта, язык-moon?, отступ от левого края, тело самого скрипта, координаты его начала в файле
--
local function Prepare1(param) -- обработать одну функцию; на выходе имя функции, её тело, имя файла
--
local d,l1,l2,file,fname,fname2,fbody,fmoon,text,prefix
--
local function SearchRename(fnname) -- поищем переприсвоение имени функции
local name = text:match("[^%a_%.]([%a_%.][%w_%.]*)%s*=%s*"..fnname.."[^%w_%.]") -- ищем конструкцию 'что-то=fnname'
return name and SearchRename(name) or fname -- ура, нашли
end
--
if not item[param] then return {body=""} end -- нет такой функции - вернём пустую строку в качестве её тела
d = debug.getinfo(item[param]) l1,l2,file = d.linedefined,d.lastlinedefined,d.source -- начало, конец, содержащий файл
if file:sub(1,1)~="@" then return {body=file} else file = file:sub(2) end -- если это не файл, вернём, что есть, иначе уберём "@" перед именем файла
if not win.GetFileAttr(file) then return {} end -- файла нет? Вернём ничего
fmoon = file:lower():match("%.moon$") -- признак языка файла функции
if fmoon then l1 = MoonLine(file,l1)+1 end --!!!плохо определяется строка!!!
repeat -- если Macro/Event и { на разных строках, то выходит ошибка, поэтому покрутим
  text = regex.gsub("--\n"..Read(file).."\n",fmoon and "/(.*?^(?!--).*?\n)/sm" or ".*?\n","",l1) -- достанем текст функции с остатком файла
  if text=="\n" then return {} end -- не смогли - уйдём, как будто и нет
  if not fmoon then text = regex.match(text,(".*?[\r\n]"):rep(l2-l1+1)) or "" end -- для lua достанем строки с текстом функции
  fname = text:match(fmoon and "^[ \t]*([%a_%.][%w_%.]*)%s*=[^\r\n]*%->" or "function%s*([%a_%.][%w_%.]*)%s*%b()") -- выдернем имя функции
  if fmoon then -- .moon?
    prefix,fbody,text = text:match("^(%s*)"..(fname and "("..fname.."%s*=" or param.."%s*:%s*(").."[^\n]*%->[^\n]*\n)(.*)") -- отступ, начало, остаток
    if fbody then fbody = fbody..regex.match(text,"/(.*?)^(?!"..prefix.."\\s)\\s*(?!--)/sm") end -- остаток функции
  else -- .lua
    fbody = text:match(fname and ".-(function.-"..fname.."%s*%b().*end).-" or ".-(function%s*%b().*end).-") -- получим тело функции
  end
  if fbody then break end -- нашли? Всё, идём дальше
  l1 = l1-1 -- повторим всё заново, но на одну строку ближе к началу
until false
if fname then -- функция определена внутри макроса?
  fname2 = SearchRename(fname) -- прокрутим имя функции на переприсвоение
  if item.FileName then
    text,fmoon = Read(item.FileName),item.FileName:lower():match("%.moon$") -- получим всё содержимое файла со скриптом, тип скрипта
    if text:find(param..(fmoon and "%s*:%s*" or "%s*=%s*")..fname2) then fname = fname2 end -- вызывается под вторым именем? Ладно.
  end
end
return {body=fbody,name=fname,file=file} -- нашли вызов данной функции в Macro/Event? Вернём
end
-- начало кода PrepareFiles
if item.code then return{stype=GetType(item),sbody=item.FileName and Read(item.FileName),o={body=item.code}} end -- клавиатурный макрос - всё просто
local res,text,prefix = {stype=GetType(item),smoon=(item.FileName or ""):lower():match("%.moon$")} -- тип скрипта, признак языка файла функции
if item.name then res.sbody = Read(item.realname) return res end -- для модуля всё ещё проще
if type(item.text)=="function" then res.t = Prepare1("text") end -- достаём text, если есть
if item.Info then for _,f in ipairs(FuncNames) do res[f] = Prepare1(f) end -- панельный модуль - достаём функции, если есть
else res.c,res.a = Prepare1("condition"),Prepare1("action") end -- достаём conition/action, если есть
if item.FileName and win.GetFileAttr(item.FileName) then -- есть, откуда вытянуть тело?
  local tbl = {} -- таблица для скриптов-кандидатов
  local _0,Proc = function() return end,function (arg) tbl[#tbl+1] = {t=arg,l=debug.getinfo(2,"l").currentline} end -- функции для доставания
  local lf = res.smoon and require"moonscript".loadfile(item.FileName) or loadfile(item.FileName) -- загрузим файл с исходным текстом
  if not lf then return res end -- не загрузился? уйдём с тем, что есть
  local e = {Macro=_0,Event=_0,NoMacro=_0,NoEvent=_0,MenuItem=_0,NoMenuItem=_0,CommandLine=_0,NoCommandLine=_0,PanelModule=_0,NoPanelModule=_0,
             [res.stype]=Proc} -- псевдоокружение
  setfenv(lf,setmetatable(e,{__index=_G}))(item.FileName) -- выполним и вытащим кандидатов на искомый скрипт
  if item.id then
    for _, v in ipairs(tbl) do -- переберём всех кандидатов
      local id = v.t.id or v.t.uid or ("≈%s: %s"):format(item.FileName:match"[^\\]+$",v.t.description or 'nil') -- !!!функция-костыль!!!
      if item.id:upper()==id:upper() then res.sstarty = v.l res.src = v.t break end -- нашли? запомним номер первой строки - и всё
    end
  elseif item.Info and item.Info.Guid then -- PanelModule всегда имеет Info.Guid
    for _, v in ipairs(tbl) do -- переберём всех кандидатов
      if item.Info.Guid==v.t.Info.Guid then res.sstarty = v.l res.src = v.t break end -- нашли? запомним номер первой строки
    end
  elseif item.guid then -- MenuItem всегда имеет guid
    for _, v in ipairs(tbl) do -- переберём всех кандидатов
      if item.guid==win.Uuid(v.t.guid) then res.sstarty = v.l item.text = v.t.text res.src = v.t break end -- нашли? запомним номер первой строки
    end
  elseif item.prefix or item.prefixes then -- CommandLine можно сравнивать только по своим параметрам
    local a1,p1,d1,a2,p2,d2 = debug.getinfo(item.action or exit),(item.prefix or item.prefixes):lower(),item.description -- переменные для сравнения
    for _, v in ipairs(tbl) do -- переберём всех кандидатов
      a2,p2,d2 = debug.getinfo(v.t.action or exit),v.t.prefixes:lower(),v.t.description -- кандидат
      if a1.source==a2.source and a1.linedefined==a2.linedefined and a1.lastlinedefined==a2.lastlinedefined and (d1==d2 or not d2 and d1=="") and
        (":"..p2..":"):find(":"..p1..":",1,true) then res.sstarty = v.l item.prefixes = p2 res.src = v.t break end -- нашли? запомним и закончим
    end
  else
    local d11,d12,a1,g1,de1,k1,d21,d22,a2,g2,de2,k2 -- определим переменные для сравнения (x1? - скрипт, x2? - кандидат)
    d11,d12,a1,g1,de1,k1 = debug.getinfo(item.condition or eval),debug.getinfo(item.action or exit),item.area,item.group,item.description,item.key
    for _, v in ipairs(tbl) do -- переберём всех кандидатов
      d21,d22,a2,g2,de2,k2 = debug.getinfo(v.t.condition or eval),debug.getinfo(v.t.action or exit),v.t.area,v.t.group,v.t.description,v.t.key
      if d11.source==d21.source and d11.linedefined==d21.linedefined and d11.lastlinedefined==d21.lastlinedefined and
        d12.source==d22.source and d12.linedefined==d22.linedefined and d12.lastlinedefined==d22.lastlinedefined and
        a1==a2 and g1==g2 and de1==de2 and k1==k2 then res.sstarty = v.l res.src = v.t break end -- нашли? запомним номер первой строки - и всё
    end
  end
  if not res.sstarty then return res end -- не нашли - так уйдём
  if res.smoon then res.sstarty = MoonLine(item.FileName,res.sstarty) end--!!!плохо определяется строка!!!
  local savedy = res.sstarty
  repeat -- если Macro/Event и { на разных строках, то выходит ошибка, поэтому покрутим
    text = "\n"..Read(item.FileName):gsub(".-[\r\n]","",res.sstarty-1).."\n" -- получим весь файл, начиная с нужной строки
    if not _G.utf8.utf8valid(text or "") then text = win.Utf16ToUtf8(win.MultiByteToWideChar(text,win.GetACP())) end
    if res.smoon then -- .moon?
      prefix,res.sbody,text = text:match("[\r\n]*([ \t]*)("..res.stype..".-[\r\n])(.*)") -- вычленим отступ, первую строку скрипта, остаток
      if res.sbody then res.sbody = res.sbody..regex.match(text,"/(.*?)^(?!"..prefix.."\\s)\\s*(?!--)(?!\n)/sm"):gsub("%s*$","") end -- весь скрипт
    else -- .lua
      local t = text:match(".-%b{}") or text:match(".-%b()") -- обрежем остаток для исключения ненужных совпадений
      res.sbody = t:match(res.stype.."%s*%b{}") or t:match(res.stype.."%s*%b()") -- запомним тело скрипта
    end
    if res.sbody then break end -- нашли? Всё, идём дальше
    res.sstarty = res.sstarty-1 -- повторим всё заново, но на одну строку ближе к началу
    if res.sstarty<1 then res.sstarty = savedy break end
  until false
  res.spfx,res.sstartx = prefix,res.sbody and (res.smoon and prefix:len()+1 or text:cfind(res.sbody,1,true)-1) or 1 -- запомним начало в строке
end
return res
end
--
function SetFilter(list,items) --[[установить фильтр с учётом текущего]]
local prop,bkeys = {Title=L.diFilter[items.type.."Hdr"],Bottom="F1, Ins, Space, Num+, Num-, Num*, Enter, Esc"},{{BreakKey="RETURN"},{BreakKey="F1"},
  {BreakKey="INSERT"},{BreakKey="NUMPAD0"},{BreakKey="SPACE"},{BreakKey="ADD"},{BreakKey="SUBTRACT"},{BreakKey="MULTIPLY"}}
for i=1,#items do -- отметим имеющиеся в переданном списке
  items[i].checked = (" "..list.." "):cfind(" "..(items[i].text:gsub("&",""):match("^(.*%S%s)%s*%│") or '"'..items[i].text..'" '),1,true)
end
local startlist = list -- начальный список
repeat -- рабочий цикл
  local item,pos = far.Menu(prop,items,bkeys) -- выведем меню выбора
  if not item then return startlist,nil end -- Esc - уйдём, вернём старый список
  prop.SelectIndex=pos -- запомним текущую позицию
  if item.BreakKey=="RETURN" then -- Enter
    list="" -- новый список
    for i=1,#items do -- заполним выделенными элементами
      if items[i].checked then list = list..(items[i].text:gsub("&",""):match("^(.*%S%s)%s*%│") or '"'..items[i].text..'" ') end
    end
    return list:sub(1,-2),items[pos].text:match("^(.*%S)%s*%│") or items[pos].text -- вернём список и текущий элемент
  elseif item.BreakKey=="F1" then -- F1 - выведем справку
    ShowHelp("filter")
  elseif item.BreakKey=="ADD" then -- Num+
    for i=1,#items do items[i].checked = true end -- выделим все
  elseif item.BreakKey=="SUBTRACT" then -- Num-
    for i=1,#items do items[i].checked = false end -- снимем выделение со всех
  elseif item.BreakKey=="MULTIPLY" then -- Num*
    for i=1,#items do items[i].checked = not items[i].checked end -- инвертируем выделение на всех
  else -- Ins/Space/акселератор
    items[pos].checked = not items[pos].checked -- инвертируем выделение
    prop.SelectIndex = pos+1 -- перейдём на следующий элемент
  end
until false
end
--
function SortingOrder(sSO,SV) --[[настройка сортировки]]
local HotKeys,OldSO,CurChar = {{BreakKey="RETURN"},{BreakKey="F1"},{BreakKey="SPACE"},{BreakKey="ADD"},{BreakKey="SUBTRACT"},{BreakKey="MULTIPLY"},
  {BreakKey="C+UP"},{BreakKey="C+DOWN"},{BreakKey="C+NUMPAD8"},{BreakKey="C+NUMPAD2"}},sSO,sSO:sub(1,1):upper()
repeat
  local items,pos,res,item = {},1
  for c in sSO:gmatch(".") do
    items[#items+1] = {text=SV[c:upper()],checked=far.LIsUpper(c) and UP or LO,char=c} if c:upper()==CurChar then pos =  #items end
  end
  for c,v in pairs(SV) do
    if c~="Hdr" and not sSO:upper():find(c) then items[#items+1] = {text=v,grayed=true,char=c} if c==CurChar then pos = #items end end
  end
  res,pos = far.Menu({Title=SV.Hdr,Bottom="Enter,Esc,F1,Space,Num+/-/*,CtrlUp/Down",SelectIndex=pos or 1,Id=Guids.Sort},items,HotKeys)
  item,CurChar = items[pos],items[pos] and items[pos].char:upper()
  if not res then return OldSO,nil -- Esc? вернём старое значение
  elseif res.BreakKey=="RETURN" then return sSO,true -- Enter? Вернём новое значение
  elseif res.BreakKey=="F1" then ShowHelp("sort")
  elseif (res.BreakKey=="SPACE"and item.grayed) or res.BreakKey=="ADD" then -- включить сортировку по возрастанию
    if sSO:find(item.char) then -- уже в списке?
      sSO = sSO:sub(1,pos-1)..sSO:sub(pos,pos):upper()..sSO:sub(pos+1) -- поднимем регистр буквы
    else -- нет в списке
      sSO = sSO..item.char -- добавим в конец списка
    end
  elseif (res.BreakKey=="SPACE" and item.checked==UP) or res.BreakKey=="SUBTRACT" then -- включить сортировку по убыванию
    if sSO:find(item.char) then -- уже в списке?
      sSO = sSO:sub(1,pos-1)..sSO:sub(pos,pos):lower()..sSO:sub(pos+1) -- опустим регистр буквы
    else -- нет в списке
      sSO = sSO..item.char:lower() -- добавим в конец списка
    end
  elseif (res.BreakKey=="SPACE" and item.checked==LO) or res.BreakKey=="MULTIPLY" then -- выключить сортировку
    sSO = sSO:gsub(item.char,"")
  elseif item.checked and pos>1 and(res.BreakKey=="C+UP" or res.BreakKey=="C+NUMPAD8") then -- поднять вверх на пункт
    sSO = sSO:sub(1,pos-2)..sSO:sub(pos,pos)..sSO:sub(pos-1,pos-1)..sSO:sub(pos+1)
  elseif item.checked and pos<sSO:len() and(res.BreakKey=="C+DOWN" or res.BreakKey=="C+NUMPAD2") then -- опустить вниз на пункт
    sSO = sSO:sub(1,pos-1)..sSO:sub(pos+1,pos+1)..sSO:sub(pos,pos)..sSO:sub(pos+2)
  end
until false
end
--
function FillUserControl(hDlg,Item,Text,Current) --[[заполнить буфер DI_USERCONTROL]]
if not Text then return end
local strings,rect = {},hDlg:send(F.DM_GETDLGRECT,0) -- текст по строкам,окно диалога
local C = far.AdvControl(F.ACTL_GETCOLOR,Current and far.Colors.COL_DIALOGEDITUNCHANGED or far.Colors.COL_DIALOGEDIT) -- цвет текста
local Left,Top,Height,Width = rect.Left+Item[2],rect.Top+Item[3]-1,Item[5]-Item[3]+1,Item[4]-Item[2]+1 -- координаты области вывода
for s in (Text.."\n"):gmatch("(.-)%s*[\r\n]") do -- разберём по строкам
  strings[#strings+1] = s:gsub("(.-)(\t)",function(p1) return p1..(" "):rep(8-p1:len()%8) end)
end
for i = 1,Height do -- выведем, что влезет, дополнив пробелами
  far.Text(Left,Top+i,C,((strings[i] or "")..(" "):rep(Width)):sub(1,Width))
end
end
--
function EditFun(src,what,def,dlg,item,w2) --[[редактирование condition/action/etc]]
local tfn,dr = far.MkTemp()..item.FileName:lower():match("%..-$"),dlg:send(F.DM_GETDLGRECT,0) -- временный файл, окно диалога
Write(tfn,src=="" and def or src) -- заполним файл
editor.Editor(tfn,(item.descr or item.description)..". "..L.diEdit[what]:gsub("&",""):gsub("^. ","")..(w2 or ""), -- отредактируем через дырочку
  dr.Left+4,dr.Top+2,dr.Right-4,dr.Bottom-2,F.EF_DISABLEHISTORY+F.EF_DISABLESAVEPOS)
local text = string.gsub(Read(tfn),"^\239\187\191","") -- новое значение
win.DeleteFile(tfn) -- больше не нужен
return (src=="" and text==def) and "" or text -- вернём пустой текст, если было пусто
end
--
function CreateAsText(lm,dfn,dft) --[[Создание нового элемента]]
--
local function DlgProc(hDlg,Msg,Param1) -- обработка событий диалога
if Msg == F.DN_EDITCHANGE then -- изменение поля имени файла?
  hDlg:send(F.DM_SETTEXT,1,L.diCreate.Hdr..(win.GetFileAttr(hDlg:send(F.DM_GETTEXT,Param1)) and L.diCreate.ExistingFile or L.diCreate.NewFile))
elseif Msg==F.DN_KILLFOCUS and Param1==2 then -- уход с имени файла?
  local nv = hDlg:send(F.DM_GETTEXT,Param1) -- новое значение
  if not regex.find(nv,"/\\.(lua|moon)$/i") and nv~="" then hDlg:send(F.DM_SETTEXT,Param1,nv..".lua") end -- имя без расширения - добавим ".lua"
elseif Msg==F.DN_CLOSE then -- закрываем диалог?
  hDlg:send(F.DM_SETFOCUS,Param1)
  if dfn and not hDlg:send(F.DM_GETTEXT,2):match("%S") then hDlg:send(F.DM_SETFOCUS,2) return ((Param1>3)and(Param1<9)) and 0 or 1 end
end
end
--
local y,tfn,idx = dfn and 4 or 2,far.MkTemp()..(lm or".lua"),(dfn and(win.GetFileAttr(dfn)and"ExistingFile"or"NewFile")or"EditedFile")
local Form = {-- диалог выбора типа скрипта
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76, y+2,0,0,0,0,L.diCreate.Hdr..L.diCreate[idx]},
--[[02]] dfn
     and {F.DI_EDIT,        5, 2,74, 2,0,"LMFileName",0,F.DIF_HISTORY,dfn}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""},
--[[03]] {F.DI_TEXT,        7, 3, 0, 3,0,0,0,dfn and F.DIF_SEPARATOR or 0,""},
--[[04]] {F.DI_BUTTON,      0, y  , 0, y  ,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,"&1 Macro"},
--[[05]] {F.DI_BUTTON,      0, y  , 0, y  ,0,0,0,F.DIF_CENTERGROUP,"&2 Event"},
--[[06]] {F.DI_BUTTON,      0, y  , 0, y  ,0,0,0,F.DIF_CENTERGROUP,"&3 MenuItem"},
--[[07]] {F.DI_BUTTON,      0, y+1, 0, y+1,0,0,0,F.DIF_CENTERGROUP,"&4 CommandLine"},
--[[08]] {F.DI_BUTTON,      0, y+1, 0, y+1,0,0,0,F.DIF_CENTERGROUP,"&5 PanelModule"},
--[[09]] {F.DI_BUTTON,      0, y+1, 0, y+1,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
local newitem,fun,ans = {{FileName=tfn,area="Common",key="",flags=0,descr="NewMacro"},
                         {FileName=tfn,group="ExitFAR",descr="NewEvent"},
                         {FileName=tfn,guid=win.Uuid(),description="",descr="NewMenuItem",text=function() end,flags={}},
                         {FileName=tfn,prefix="",description=""},
                         {FileName=tfn,description="",Info={Guid=win.Uuid()}}},
                        {OpenMacroInDialog,OpenEventInDialog,OpenMenuItemInDialog,OpenPrefixInDialog,OpenPanelModuleInDialog},
                        dft or far.Dialog(Guids.CreateNew,-1,-1,80,y+4,nil,Form,nil,DlgProc)-3
if ans==1 or ans == 2 or ans==3 or ans == 4 or ans == 5 then -- Macro/Event/MenuItem/CommandLine/PanelModule
  Write(tfn,"") -- создадим временный файл
  local ok,errmess = fun[ans](newitem[ans],true) -- отредактируем рыбу
  local text = Read(tfn) -- получим всё содержимое временного файла
  win.DeleteFile(tfn) -- больше не нужен
  return ok and text,errmess,Form[2][10]
end
return ""
end
--
function DoIt(fun,ETtl,...) local ok,er = fun(...) if not ok and er then ErrMess(er,ETtl) end return ok,er end --[[обработка действия и вывод ошибки]]
--
function GetType(item) --[[получить тип элемента]]
return (item.Info and "PanelModule") or ((item.prefix or item.prefixes) and "CommandLine") or (item.guid and "MenuItem") or
  (item.name and "Module") or (item.group and "Event") or (item.code and "KeyMacro") or (item.area and "Macro")
end
--
function ShowHelp(text) far.ShowHelp(Path,text,F.FHELP_CUSTOMPATH) end --[[вывести справку]]
--
if type(nfo)=="table" then nfo.help = function() ShowHelp() end end
--
function Read(f) local h,e = DoIt(io.open,"",f,"r") if e then return "",e end local t = h:read("*a") h:close() return t end --[[прочитать весь файл]]
--
function Write(f,t,a)local h,e = DoIt(io.open,"",f,a and"a"or"w") if e then return h,e else h:write(t)h:close() return h end end --[[записать в файл]]
--
function Replace(fn,old,new) --[[заменить текст в файле]]
local t,er = Read(fn) if er then return nil,er else local b,e = t:cfind(old,1,true) return Write(fn,b and t:sub(1,b-1)..new..t:sub(e+1) or t) end
end
--
function ErrMess(msg,ttl) far.Message(msg,ttl or nfo.name,";Ok","w") end --[[вывести сообщение об ошибке]]
--
function FMatch(f,m) return mf.fmatch(m:find("\\") and f or f:match("[^\\]*$"),m) end --[[сравнить по файловой маске]]
--------------------------------------------------------------------------------
-- +
--[==[Показать информацию]==]
-- -
function ShowInfo(item)
--
local MacroFlagsByInt = {
  [0x00000001] = "EnableOutput",
  [0x00000002] = "NoSendKeysToPlugins",
  [0x00000008] = "RunAfterFARStart",
  [0x00000010] = "EmptyCommandLine",
  [0x00000020] = "NotEmptyCommandLine",
  [0x00000040] = "EVSelection",
  [0x00000080] = "NoEVSelection",
  [0x00000100] = "Selection",
  [0x00000200] = "PSelection",
  [0x00000400] = "NoSelection",
  [0x00000800] = "NoPSelection",
  [0x00001000] = "NoFilePanels",
  [0x00002000] = "NoFilePPanels",
  [0x00004000] = "NoPluginPanels",
  [0x00008000] = "NoPluginPPanels",
  [0x00010000] = "NoFolders",
  [0x00020000] = "NoPFolders",
  [0x00040000] = "NoFiles",
  [0x00080000] = "NoPFiles",
}
local conf={indent="    ",prefix=L.diShow.Space,links={[_G]="_G",[_G.far.Flags]="far.Flags",[_G.far.Colors]="far.Colors",[_G.far.Guids]="far.Guids"}}
--
local function SortedTable(tbl) -- преобразуем и отсортируем таблицу
local res,ttypes = {},{table=1,["function"]=2,boolean=3,number=4,string=5,thread=6,userdata=7} -- результат, таблица типов
for n,v in pairs(tbl) do res[#res+1] = {n=n,v=v,nt=ttypes[type(n)] or 9,vt=ttypes[type(v)] or 9} end -- скопируем; страховка на случай нест. типов
table.sort(res,function(a,b) return a.nt..a.vt..a.n<b.nt..b.vt..b.n end) -- отсортируем по типам и именам
return res
end
--
local function AddParam(array,val,name,level,params,slist,parent) -- добавим параметр, раскрутим, если таблица
local indent,pref1,prefix,links = params.indent or "  ",params.pref1 or params.prefix or "",params.prefix or "",params.links or {}
if type(parent)=="table" and type(name)~="string" then name = "["..tostring(name).."]" end
local s0 = ("%s%s<%-9s %s = "):format(level==0 and pref1 or prefix,indent:rep(level),type(val)..">",name) -- начало строки
for a,s in pairs(links) do if val==a then array[#array+1] = {text=s0.."-> "..s,item=val} links = nil break end end
if links then
  local q = type(val)=="string" and '"' or ''
  array[#array+1] = {text=s0..q..tostring(val)..q,item=val} -- добавим строку
  if type(val)=="table" and S.TableRecursion then -- таблица?
    local tname -- имя таблицы-предка
    for a,n in pairs(slist) do if val==a then tname = n break end end -- если таблица ссылается на одну из уже развёрнутых, запомним
    if tname then -- такая таблица уже есть в списке?
      array[#array].text = s0:sub(1,-3)..(slist[parent]:match("^"..tname) and "-^ " or "-> ")..tname -- исправим текст
    else -- не предок
      slist[val] = (slist[parent] and slist[parent]..(name:sub(-1)=="]" and "" or ".") or "")..name -- запомним в списке развёрнутых таблиц
      array[#array+1] = {text=prefix..indent:rep(level+1).."{",item=val}
      for _,t in ipairs(SortedTable(val)) do AddParam(array,t.v,t.n,level+1,params,slist,val) end -- вызовем себя с каждым элементом таблицы
      array[#array+1] = {text=prefix..indent:rep(level+1).."}",item=val}
    end
  end
end
end
--
local function ProcessFunction(fun,subtitle,body,array) -- добавим action/condition/etc
--
local l1,env = #array,getfenv(fun)
if body then -- текст функции есть?
  for s in body:gmatch("([^\r\n]+)") do array[#array+1] = {text=(#array==l1 and subtitle or L.diShow.Space)..s,item=fun} end -- добавим строки
else -- нет
  array[#array+1] = {text=subtitle..L.diShow.NotFound} -- так и скажем
end
if env==_G then
  array[#array+1] = {text=L.diShow.Env.."<table> _G",item=_G}
else
  conf.pref1 = L.diShow.Env -- префикс для первой строки первой переменной
  for _,t in ipairs(SortedTable(env)) do AddParam(array,t.v,t.n,0,conf,{}) conf.pref1 = nil end -- добавим окружение
end
local upv = {} -- таблица для upvalues
for i = 1,debug.getinfo(fun).nups do local n,v = debug.getupvalue(fun,i) upv[n] = v end -- заполним таблицу
conf.pref1 = L.diShow.Upv -- префикс для первой строки первой переменной
for _,t in ipairs(SortedTable(upv)) do AddParam(array,t.v,t.n,0,conf,{}) conf.pref1 = nil end -- добавим окружение
end
-- начало кода
repeat
  local strings,sf,D = {},"",PrepareFiles(item) -- список вывода, флаги как строка, разобранный скрипт
  if item.disabled then strings[#strings+1] = {text=L.diShow.Space..L.diShow.Disabled,item=item.disabled} -- заполним данными
                        strings[#strings+1] = {text=L.diShow.Space} end
  strings[#strings+1] = {text=L.diShow[(item.FileName or ""):sub(-1)=="\\" and "Dir" or "File"]..(item.FileName or L.Absent),item=item.FileName}
  if item.needsave then strings[#strings+1] = {text=L.diShow.Space..L.diShow.NeedSave,item=item.needsave} end
  if item.Info then -- PanelModule?
    strings[#strings+1] = {text=L.diShow.guid..win.Uuid(item.Info.Guid),item=win.Uuid(item.Info.Guid)}
    strings[#strings+1] = {text=L.diShow.Name..(item.Info.Title and item.Info.Title or L.Absent),item=item.Info.Title}
    strings[#strings+1] = {text=L.diShow.Desc..(item.Info.Description~="" and item.Info.Description or L.Absent),item=item.Info.Description}
    strings[#strings+1] = {text=L.diShow.Author..(item.Info.Author and item.Info.Author or L.Absent),item=item.Info.Author}
    strings[#strings+1] = {text=L.diShow.Version..(item.Info.Version and item.Info.Version or L.Absent),item=item.Info.Version}
    for _,f in ipairs(FuncNames) do if item[f] then ProcessFunction(item[f],f..":"..L.diShow.Space:sub(f:len()+2),D[f].body,strings) end end
  elseif item.prefix then -- CommandLine?
    item.prefixes = nil -- уберём лишнее
    strings[#strings+1] = {text=L.diShow.Desc..(item.description~="" and item.description or L.Absent),item=item.description}
    strings[#strings+1] = {text=L.diShow.Prefix..item.prefix,item=item.prefix}
    if item.action then
      ProcessFunction(item.action,L.diShow.Code,D.a.body,strings)
    else
      strings[#strings+1] = {text=L.diShow.Code..L.Absent}
    end
  elseif item.guid then -- MenuItem?
    strings[#strings+1] = {text=L.diShow.guid..win.Uuid(item.guid),item=win.Uuid(item.guid)}
    strings[#strings+1] = {text=L.diShow.index..item.index,item=item.index}
    strings[#strings+1] = {text=L.diShow.Desc..(item.description~="" and item.description or L.Absent),item=item.description}
    local tmenu,sarea,smenu = {plugins="Plugins",config="Config",disks="Disks"},"",""
    for i,v in pairs(tmenu) do if item.flags[i] then smenu = smenu..v.." " end end
    for i,v in pairs(Areas) do if item.flags[i] then sarea = sarea..v.." " end end
    strings[#strings+1] = {text=L.diShow.FarMenu..smenu,item=smenu}
    strings[#strings+1] = {text=L.diShow.Area..sarea,item=sarea}
    if type(item.text)=="function" then
      ProcessFunction(item.text,L.diShow.MenuItem,D.t.body,strings)
    else
      strings[#strings+1] = {text=L.diShow.MenuItem..item.text,item=item.text}
    end
    if item.action then
      ProcessFunction(item.action,L.diShow.Code,D.a.body,strings)
    else
      strings[#strings+1] = {text=L.diShow.Code..L.Absent}
    end
  elseif item.name then -- модуль
    strings[#strings+1] = {text=L.diShow.Name..item.name,item=item.name} -- заполним данными
    strings[#strings+1] = {text=L.diShow.Src..item.type,item=item.type}
    strings[#strings+1] = {text=L.diShow.Base..item.mask,item=item.mask}
    strings[#strings+1] = {text=L.diShow.RBase..item.realbase,item=item.realbase}
    if package.loaded[item.name] then -- если модуль загружен
      conf.pref1 = L.diShow.Res
      AddParam(strings,item.res,L.diShow.Res:match("(.*):"),0,conf,{}) -- возвращаемое значение с раскруткой таблиц
    else -- если не загружен, так и скажем
      strings[#strings+1] = {text=L.diShow.Res..L.diShow.NotLoaded,item=L.diShow.NotLoaded}
    end
  elseif item.area or item.group then -- Macro/Event?
    if item.flags then for i,v in pairs(MacroFlagsByInt) do if band(i,item.flags)~=0 then sf = sf..v.." " end end end -- переведём флаги в строку
    if item.id then strings[#strings+1] = {text=L.diShow.id..item.id,item=item.id} end
    strings[#strings+1] = {text=L.diShow.index..item.index,item=item.index}
    local l0 = #strings
    for s in (item.descr:sub(1,1)=="'" and item.description or L.Absent):gmatch("[^\n]+") do
      strings[#strings+1] = {text=(l0==#strings and L.diShow.Desc or L.diShow.Space)..s,item=item.description}
    end
    if item.area then strings[#strings+1] = {text=L.diShow.Area..item.area,item=item.area} end
    if item.key then strings[#strings+1] = {text=L.diShow.Key..item.key,item=item.key} end
    if item.flags then strings[#strings+1] = {text=L.diShow.Flags..(item.flags~=0 and sf or L.diShow.Default),item=item.flags} end
    if item.group then strings[#strings+1] = {text=L.diShow.Group..item.group,item=item.group} end
    if item.filemask then strings[#strings+1] = {text=L.diShow.Mask..item.filemask,item=item.filemask} end
    if item.code then
      strings[#strings+1] = {text=L.diShow.Code..item.code,item=item.code}
    else
      strings[#strings+1] = {text=L.diShow.Prio..(item.priority or L.diShow.Default),item=item.priority}
      if item.area then strings[#strings+1] = {text=L.diShow.SortPrio..(item.sortpriority or L.diShow.Default),item=item.sortpriority} end
      if item.condition then -- условие есть?
        ProcessFunction(item.condition,L.diShow.Cond,D.c.body,strings)
      else
        strings[#strings+1] = {text=L.diShow.Cond..L.Absent}
      end
      if item.action then
        ProcessFunction(item.action,L.diShow.Code,D.a.body,strings)
      else
        strings[#strings+1] = {text=L.diShow.Code..L.Absent}
      end
    end
  end
  local isrb = rb and item.id
  local res,pos = far.Menu({Flags=F.FMENU_WRAPMODE+F.FMENU_SHOWAMPERSAND,Title=L[GetType(item)], -- выведем на экран
    Bottom="F1,"..(le and "F3,AltF3," or "")..(item.name and "" or "F4,").."Alt/Ctrl/Shift/CtrlShiftF4,Del,CtrlPgDn"..(isrb and ",CtrlR/D" or "")..
    (rs and ",CtrlS" or "")..(item.name and ",CtrlL" or "").."Num+/-"},strings,{{BreakKey="F1"},le and {BreakKey="F3"},le and {BreakKey="A+F3"},
    not item.name and {BreakKey="F4"},{BreakKey="A+F4"},{BreakKey="C+F4"},{BreakKey="S+F4"},{BreakKey="CS+F4"},{BreakKey="DELETE"},
    {BreakKey="DECIMAL"},{BreakKey="C+NEXT"},{BreakKey="C+NUMPAD3"},item.name and {BreakKey="C+L"},isrb and {BreakKey="C+R"},
    (isrb or item.name) and {BreakKey="C+D"},rs and {BreakKey="C+S"},{BreakKey="ADD"},{BreakKey="SUBTRACT"}})
  if not res or not res.BreakKey then break end -- Enter или Esc? Всё
  if res.BreakKey=="F1" then -- F1 - выведем справку
    ShowHelp("show")
  elseif res.BreakKey=="F3" then -- открыть в LuaExplorer текущий пункт?
    le({[strings[pos].text]=strings[pos].item}) -- сделаем
  elseif res.BreakKey=="A+F3" then -- открыть в LuaExplorer скрипт?
    local descr = item.descr item.descr = nil le(item) item.descr = descr -- сделаем
  elseif res.BreakKey=="F4" then -- редактировать в диалоге?
    if item.Info then -- панельный модуль?
      DoIt(OpenPanelModuleInDialog,L.diEditPanelModule,item) -- сделаем
    elseif item.prefix then -- префикс?
      DoIt(OpenPrefixInDialog,L.diEditCommandLine,item) -- сделаем
    elseif item.guid then -- пункт меню плагинов?
      DoIt(OpenMenuItemInDialog,L.diEditMenuItem,item) -- сделаем
    elseif item.name then -- модуль?
      DoIt(OpenInEditor,L.edEditModule,item,false) -- сделаем
    elseif item.group then -- обработчик событий
      DoIt(OpenEventInDialog,L.diEditEvent,item) -- сделаем
    elseif item.code then -- клавиатурный огрызок?
      DoIt(OpenInternalMacroInDialog,L.diEditKeyMacro,item) -- сделаем
    elseif item.area then -- макрос?
      DoIt(OpenMacroInDialog,L.diEditMacro,item) -- сделаем
    end
    break
  elseif regex.find(res.BreakKey,[[^(A|C)\+F4$]]) then -- редактировать во встроенном редакторе?
    DoIt(OpenInEditor,L["edEdit"..GetType(item)],item,res.BreakKey=="C+F4") if res.BreakKey=="C+F4" then return "exit" else break end -- сделаем
  elseif res.BreakKey=="S+F4" or res.BreakKey=="CS+F4" then -- редактировать строку под курсором?
    if type(strings[pos].item)=="function" then -- для функций только
      local d,c,src,l1 -- информация о функции, признак источника-файла, имя содержащего файла, номер первой строки
      d = debug.getinfo(strings[pos].item) l1,c,src = d.linedefined,d.source:match("^(.)(.*)$") -- получим
      if c=="@" and win.GetFileAttr(src) then -- источник - это существующий файл?
        local fm = res.BreakKey=="CS+F4" and F.EF_NONMODAL or nil -- с Ctrl - редактируем немодально
        editor.Editor(src,nil,nil,nil,nil,nil,fm,src:upper():find("%.LUA$") and l1 or MoonLine(src,l1),1) -- поредактируем
        far.MacroLoadAll() -- обновим
        if res.BreakKey=="CS+F4" then return "exit" end -- если немодально - уйдём отсюда, всё
      end
    end
  elseif res.BreakKey=="DELETE" or res.BreakKey=="DECIMAL" then -- удалить текущий?
    DoIt(DeleteCurrent,L.DelElement,item) break -- сделаем
  elseif res.BreakKey=="C+NEXT" or res.BreakKey=="C+NUMPAD3" then -- перейти к файлу в панели?
    if Area.Shell then
      if item.FileName then
        Panel.SetPath(0,item.FileName:match("(.*)\\([^\\]*)")) return "exit" -- перешли, всё
      else
        ErrMess(L.er.NoFile,L.goFile)
      end
    else
      ErrMess(L.er.NotFilePanel,L.goFile)
    end
  elseif res.BreakKey=="C+R" then -- переназначить клавишу с помощью Rebind?
    DoIt(Rebind,L.Rebind,item) break -- переназначим
  elseif res.BreakKey=="C+D" then -- включить/выключить с помощью Rebind?
    DoIt(Disable,L.Disable,item) -- переключим
    item.disabled = not item.disabled -- надо для корректного отображения
  elseif res.BreakKey=="C+S" then -- открыть в ScriptBrowser?
    local info = rs.getscript_byfile(item.FileName) -- поищем info для данного файла
    if info then -- нашли?
      while info.parent_id do info = rs.getscript(info.parent_id) end -- найдём родителя
      local files = {info.FileName} -- список файлов, входящих в пакет
      for _,i in ipairs(rs.scripts) do if i.parent_id==info.id then files[#files+1] = i.FileName end end -- заполним список
    S.Filter.F = table.concat(files,",")..L.PkgFilter..info.description -- изменим маску файла
    break
    else -- не нашли
      ErrMess(L.er.NoNFO,item.descr) -- так и скажем
    end
  elseif res.BreakKey=="C+L" then -- подгрузить модуль?
    local _,ret = pcall(require,item.name) -- загрузим модуль и запомним, что он возвращает
    item.res = ret
  elseif res.BreakKey=="ADD" then -- раскрывать таблицы?
    S.TableRecursion = true
  elseif res.BreakKey=="SUBTRACT" then -- не раскрывать таблицы?
    S.TableRecursion = false
  end
until false
end
-- +
--[==[Редактирование макроса в диалоге]==]
-- -
function OpenMacroInDialog(item,new,noreload)
--
local D,ov,cond,act,cbody,abody,CurrElem,defca,WasRAlt
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_BTNCLICK and Param1==4 then -- нажата кнопка генерация uid?
  hDlg:send(F.DM_SETTEXT,Param1-1,GenUid()) -- сгенерируем и запишем
elseif Msg==F.DN_EDITCHANGE and Param1==6 then -- изменилось содержимое поля ввода description?
  local s = hDlg:send(F.DM_GETTEXT,Param1)
  item.descr = (s~="") and "'"..s.."'" or item.index and "index="..item.index or "NewMacro"
elseif Msg==F.DN_EDITCHANGE and Param1==8 then -- изменилось содержимое поля ввода область?
  local EV = IsEV:find(Param2[10]) -- область - редактора или просмотрщика?
  hDlg:send(F.DM_ENABLE,18,EV) -- для редактора и просмотрщика разрешим ввод маски файла
  if not EV then hDlg:send(F.DM_SETTEXT,18,"") end -- для остальных очистим маску файла
elseif Msg==F.DN_BTNCLICK and Param1==9 then -- нажата кнопка выбор области из списка?
  local areas,ok = SetFilter(hDlg:send(F.DM_GETTEXT,Param1-1),L.AreaItems) -- выберем
  if ok then hDlg:send(F.DM_SETTEXT,Param1-1,areas) end -- запишем
elseif Msg==F.DN_BTNCLICK and Param1==12 then -- нажата кнопка ввод клавиши?
  hDlg:send(F.DM_SETTEXT,Param1-1,(hDlg:send(F.DM_GETTEXT,Param1-1).." "..MacroKey(hDlg)):match("^%s*(.-)%s*$")) -- запишем в поле
elseif Msg==F.DN_KILLFOCUS and (Param1==14 or Param1==16) then -- уход с элемента изменение приоритета исполнения или сортировки?
  local nv = tonumber(hDlg:send(F.DM_GETTEXT,Param1)) -- новое значение
  if not nv or nv>100 or nv<0 then -- плохое?
    hDlg:send(F.DM_SETTEXT,Param1,ov) -- плохое - откатим
  end
elseif Msg==F.DN_HOTKEY and (Param1==27 or Param1==28 or Param1==29) then -- нажата клавиша для перехода на флаг для активной/пассивной панели
  if WasRAlt then -- горячую клавишу вызвали с правым альтом?
    hDlg:send(F.DM_SETCHECK,Param1+4,F.BSTATE_TOGGLE) -- симулируем нажатие
    hDlg:send(F.DM_SETFOCUS,Param1+4) -- переключимся на нужный элемент
    hDlg:send(F.DM_REDRAW) -- перерисуем
    return false -- скажем системе ничего не делать
  end
elseif Msg==F.DN_DRAWDLGITEM and(Param1==36 or Param1==40) then -- рисуем вручную condition или action?
  FillUserControl(hDlg,Param2,Param1==36 and cond or act,CurrElem==Param1) -- нарисуем
elseif Msg==F.DN_CONTROLINPUT and (Param1==36 or Param1==40) then -- что-то нажали в поле текста функции?
  if ((Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1f)==0)or(Param2.EventFlags==F.DOUBLE_CLICK)) then -- F4/DblClick
    local t = EditFun(Param1==36 and cond or act,Param1==36 and "Cond" or "MCode",Param1==36 and defca.c or defca.a,hDlg,item) -- ОК
    if Param1==36 then cond = t else act = t end -- запишем, куда надо
    hDlg:send(F.DM_REDRAW) -- обновим экран
  end
  WasRAlt = band(Param2.ControlKeyState,0x01)~=0 -- запомним состояние RAlt
elseif Msg==F.DN_BTNCLICK and(Param1==37 or Param1==41) then -- нажата кнопка редактировать функцию?
  if Param1==37 then local t = EditFun(cbody or cond,"CondBody",defca.c,hDlg,item) if cbody then cbody = t else cond = t end
  else local t = EditFun(abody or act,"CodeBody",defca.a,hDlg,item) if abody then abody = t else act = t end end -- поредактируем и запишем, куда надо
  hDlg:send(F.DM_REDRAW) -- обновим диалог
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0 then -- нажатие F1
  ShowHelp("edit")
elseif Msg==F.DN_GOTFOCUS then -- переход на элемент?
  CurrElem = Param1 -- запомним текущий элемент
  if Param1==14 or Param1==16 then ov = hDlg:send(F.DM_GETTEXT,Param1) end -- изменение приоритета? запомним старое значение
elseif Msg==F.DN_CLOSE then -- закрываем диалог?
  hDlg:send(F.DM_SETFOCUS,6) -- переключимся на description
end
end
--
local function f01(is1) return band(is1,item.flags)/is1 end
local function f012(is1,is0) return band(is1,item.flags)~=0 and 1 or band(is0,item.flags)~=0 and 0 or 2 end
-- начало кода функции
if not (item.FileName and win.GetFileAttr(item.FileName)) then
  return false,L.Macro.." "..item.descr..". "..L.er.NoFile
end
if new then cond,act,D = "","",{smoon=item.FileName:lower():match("%.moon$"),spfx="",src={}} -- новый макрос - сделаем заглушки
else
  D = PrepareFiles(item) -- достанем всё
  if not D.sbody then -- скрипт не найден?
    if far.Message(L.Macro.." "..item.descr..L.er.NotFound..".\n"..L.edEditMacro.."?",nfo.name,";OkCancel")==1 then
      return OpenInEditor(item) else return false,L.Macro.." "..item.descr..L.er.NotFound end
  end
  if D.c.name then cond,cbody = D.c.name,D.c.body else cond = D.c.body end
  if D.a.name then act,abody = D.a.name,D.a.body else act = D.a.body end
end
--
local Y = cond and math.floor((Far.Height+11)/2) or 18 -- начало action
local Form = {-- диалог редактирования макроса
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76,Far.Height-2,0,0,0,0,L.diEdit.MacroHdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diEdit.id},
--[[03]] {F.DI_EDIT,       19, 2,58, 2,0,"",0,0,item.id or D.src.uid or GenUid()},
--[[04]] {F.DI_BUTTON,     60, 2, 0, 2,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.GenUid},
--[[05]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diEdit.Desc},
--[[06]] {F.DI_EDIT,       19, 3,74, 3,0,"MacroDescription",0,F.DIF_HISTORY,item.description or ""},
--[[07]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diEdit.Area},
--[[08]] {F.DI_EDIT,       19, 4,61, 4,0,"",0,0,item.area},
--[[09]] {F.DI_BUTTON,     63, 4, 0, 4,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.Sel},
--[[10]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0,L.diEdit.Key},
--[[11]] {F.DI_EDIT,       19, 5,61, 5,0,"",0,0,item.key},
--[[12]] {F.DI_BUTTON,     63, 5, 0, 5,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.Add},
--[[13]] {F.DI_TEXT,        5, 6, 0, 6,0,0,0,0, L.diEdit.Prio},
--[[14]] {F.DI_FIXEDIT,    19, 6,21, 6,0,0,0,0,item.priority or 50},
--[[15]] {F.DI_TEXT,       23, 6, 0, 6,0,0,0,0, L.diEdit.SortPrio},
--[[16]] {F.DI_FIXEDIT,    36, 6,38, 6,0,0,0,0,item.sortpriority or 50},
--[[17]] {F.DI_TEXT,       40, 6, 0, 6,0,0,0,0,L.diEdit.Mask},
--[[18]] {F.DI_EDIT,       48, 6,74, 6,0,"MacroFileMask",0,F.DIF_HISTORY+(IsEV:find(item.area) and 0 or F.DIF_DISABLE),item.filemask or ""},
--[[19]] {F.DI_TEXT,       -1, 7, 0, 7,0,0,0,F.DIF_SEPARATOR,""},
--[[20]] {F.DI_TEXT,        5, 7, 0, 7,0,0,0,0,L.diEdit.FlagsHdr},
--[[21]] {F.DI_CHECKBOX,    5, 8, 0, 8,f01(0x1),0,0,0,L.diEdit.Flags.Output}, -- "EnableOutput"
--[[22]] {F.DI_CHECKBOX,    5, 9, 0, 9,f01(0x8),0,0,0,L.diEdit.Flags.OnStart}, -- "RunAfterFarStart"
--[[23]] {F.DI_CHECKBOX,   41, 9, 0, 9,f012(0x10,0x20),0,0,F.DIF_3STATE,L.diEdit.Flags.EmptyCS}, -- "NotEmptyCommandLine" or "EmptyCommandLine"
--[[24]] {F.DI_CHECKBOX,    5,10, 0,10,f01(0x2),0,0,0,L.diEdit.Flags.Keys}, -- "NoSendKeysToPlugins"
--[[25]] {F.DI_CHECKBOX,   41,10, 0,10,f012(0x40,0x80),0,0,F.DIF_3STATE,L.diEdit.Flags.Sel}, -- "NoEVSelection" or "EVSelection"
--[[26]] {F.DI_TEXT,        5,11, 0,11,0,0,0,0,L.diEdit.Flags.Act},
--[[27]] {F.DI_CHECKBOX,    6,12, 0,12,f012(0x1000,0x4000),0,0,F.DIF_3STATE,L.diEdit.Flags.PlugFile}, -- "NoFilePanels" or "NoPluginPanels"
--[[28]] {F.DI_CHECKBOX,    6,13, 0,13,f012(0x10000,0x40000),0,0,F.DIF_3STATE,L.diEdit.Flags.FolFile}, -- "NoFiles" or "NoFolders"
--[[29]] {F.DI_CHECKBOX,    6,14, 0,14,f012(0x100,0x400),0,0,F.DIF_3STATE,L.diEdit.Flags.FileSel}, -- "NoSelection" or "Selection"
--[[30]] {F.DI_TEXT,       41,11, 0,11,0,0,0,0,L.diEdit.Flags.Pass},
--[[31]] {F.DI_CHECKBOX,   42,12, 0,12,f012(0x2000,0x8000),0,0,F.DIF_3STATE,L.diEdit.Flags.PlugFile}, -- "NoFilePPanels" or "NoPluginPPanels"
--[[32]] {F.DI_CHECKBOX,   42,13, 0,13,f012(0x20000,0x80000),0,0,F.DIF_3STATE,L.diEdit.Flags.FolFile}, -- "NoPFiles" or "NoPFolders"
--[[33]] {F.DI_CHECKBOX,   42,14, 0,14,f012(0x200,0x800),0,0,F.DIF_3STATE,L.diEdit.Flags.FileSel}, -- "NoPSelection" or "PSelection"
--[[34]] {F.DI_TEXT,       -1,15, 0,15,0,0,0,F.DIF_SEPARATOR,""},
--[[35]] {F.DI_TEXT,        5,15, 0,15,0,0,0,0,L.diEdit.Cond..L.diEdit.F4},
--[[36]] cond
     and {F.DI_USERCONTROL, 5,16,74,Y-1,0}
      or {F.DI_TEXT,        5,16, 0,16,0,0,0,0,L.diEdit.CondNotInFile1},
--[[37]]  cond
     and (cbody -- тело внутри - отдельных кнопок не надо
     and {F.DI_BUTTON,     40,15, 0,15,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.CondBody}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""})
      or {F.DI_TEXT,        5,17, 0,17,0,0,0,0,L.diEdit.CondNotInFile2},
--[[38]] {F.DI_TEXT,       -1, Y, 0, Y,0,0,0,F.DIF_SEPARATOR,""},
--[[39]] {F.DI_TEXT,        5, Y, 0, Y,0,0,0,0,L.diEdit.MCode..L.diEdit.F4},
--[[40]] act
     and {F.DI_USERCONTROL, 5,Y+1,74,Far.Height-5,0}
      or {F.DI_TEXT,        5,Y+1, 0,Y+1,0,0,0,0,L.diEdit.CodeNotInFile1},
--[[41]] act
     and (abody -- тело внутри - отдельных кнопок не надо
     and {F.DI_BUTTON,     40, Y, 0, Y,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.CodeBody}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""})
      or {F.DI_TEXT,        5,Y+2, 0,Y+2,0,0,0,0,L.diEdit.CodeNotInFile2},
--[[42]] {F.DI_TEXT,       -1,Far.Height-4, 0,Far.Height-4,0,0,0,F.DIF_SEPARATOR,""},
--[[43]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[44]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
defca = Templates.Macro[D.smoon and "moon" or "lua"] -- пустые condition и action
repeat
local errs = ""
  if far.Dialog(Guids.MacroEdit,-1,-1,80,Far.Height,nil,Form,nil,DlgProc)~=43 then return true end -- не "ОК" - уйдём
  if Form[8][10]=="" then errs = errs..L.er.NoArea end -- нет области? Ошибка
  if act=="" then errs = errs..L.er.NoCode end -- нет обработчика? Ошибка
until errs=="" or far.Message(L.Macro..L.er.NoPart..errs,L.diEdit.MacroHdr,L.er.NoPartKeys)==1 -- повторяем, если не устраивает
if Form[3][10]=="" then Form[3][10] = GenUid() end -- нет id/uid? - тут мы можем поправить автоматом
local flags = ((Form[21][6]==1 and " EnableOutput" or "").. -- сформируем новые флаги
  (Form[22][6]==1 and " RunAfterFARStart" or "")..
  (Form[23][6]==0 and " NotEmptyCommandLine" or "")..(Form[23][6]==1 and " EmptyCommandLine" or "")..
  (Form[24][6]==1 and " NoSendKeysToPlugins" or "")..
  (Form[25][6]==0 and " NoEVSelection" or "")..(Form[25][6]==1 and " EVSelection" or "")..
  (Form[27][6]==0 and " NoPluginPanels" or "")..(Form[27][6]==1 and " NoFilePanels" or "")..
  (Form[28][6]==0 and " NoFolders" or "")..(Form[28][6]==1 and " NoFiles" or "")..
  (Form[29][6]==0 and " NoSelection" or "")..(Form[29][6]==1 and " Selection" or "")..
  (Form[31][6]==0 and " NoPluginPPanels" or "")..(Form[31][6]==1 and " NoFilePPanels" or "")..
  (Form[32][6]==0 and " NoPFolders" or "")..(Form[32][6]==1 and " NoPFiles" or "")..
  (Form[33][6]==0 and " NoPSelection" or "")..(Form[33][6]==1 and " PSelection" or "")):sub(2)
local IsDefPrio = Form[14][10]=="50"
local m = D.smoon and ((new and "\n" or "")..[[
%sMacro
%s  id:%q
%s  area:%q
%s%s  key:%q
%s%s  description:%q
%s%s  filemask:%q
%s%s  flags:%q
%s%s  priority:%s
%s%s  sortpriority:%s
%s%s  condition:%s
%s%s  action:%s
]]):format(D.spfx,D.spfx,Form[3][10],D.spfx,Form[8][10],Form[11][10]=="" and "--" or "",D.spfx,Form[11][10],
    Form[6][10]=="" and "--" or "",D.spfx,Form[6][10],Form[18][10]=="" and "--" or "",D.spfx,Form[18][10],
    flags=="" and "--" or "",D.spfx,flags,IsDefPrio and "--" or "",D.spfx,Form[14][10],Form[16][10]=="50" and "--" or "",D.spfx,Form[16][10],
    cond=="" and "--" or "",D.spfx,cond=="" and defca.c or cond,act=="" and "--" or "",D.spfx,act=="" and defca.a or act)
                   or ((new and "\n" or "")..[[
Macro{
  id=%q;
  area=%q;
%s  key=%q;
%s  description=%q;
%s  filemask=%q;
%s  flags=%q;
%s  priority=%s;
%s  sortpriority=%s;
%s  condition=%s;
%s  action=%s;
}
]]):format(Form[3][10],Form[8][10],Form[11][10]=="" and "--" or "",Form[11][10],
    Form[6][10]=="" and "--" or "",Form[6][10],Form[18][10]=="" and "--" or "",Form[18][10],
    flags=="" and "--" or "",flags,IsDefPrio and "--" or "",Form[14][10],Form[16][10]=="50" and "--" or "",Form[16][10],
    cond=="" and "--" or "",cond=="" and defca.c or cond,act=="" and "--" or "",act=="" and defca.a or act)
if new then Write(item.FileName,m) else Replace(item.FileName,D.sbody,m) end -- запишем новый вариант в файл
if cbody and D.c.file then Replace(D.c.file,D.c.body,cbody) end -- запишем новый текст функции condition в файл
if abody and D.a.file then Replace(D.a.file,D.a.body,abody) end -- запишем новый текст функции action в файл
return new or noreload or far.MacroLoadAll(),L.er.EMacro -- обновим макросы в Farе
end
-- +
--[==[Редактирование клавиатурного макроса в диалоге]==]
-- -
function OpenInternalMacroInDialog(item)
--
if item.needsave then -- несохранённый? если нашли чем, отредактируем, иначе скажем, что не можем. И всё на этом
  if EditUnsavedMacro then return true,EditUnsavedMacro(item.index) else return false,L.er.EditUnsavedKeyMacro end
end
--
local WasRAlt
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_HOTKEY and (Param1==16 or Param1==17 or Param1==18) then -- нажата клавиша для перехода на флаг для активной/пассивной панели
  if WasRAlt then -- горячую клавишу вызвали с правым альтом?
    hDlg:send(F.DM_SETCHECK,Param1+4,F.BSTATE_TOGGLE) -- симулируем нажатие
    hDlg:send(F.DM_SETFOCUS,Param1+4) -- переключимся на нужный элемент
    hDlg:send(F.DM_REDRAW) -- перерисуем
    return false -- скажем системе ничего не делать
  end
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0 then -- нажатие F1
  ShowHelp("edit")
elseif Msg==F.DN_CONTROLINPUT then -- что-то нажали
  WasRAlt = band(Param2.ControlKeyState,0x01)~=0 -- запомним состояние RAlt
end
end
--
local function f01(is1) return band(is1,item.flags)/is1 end
local function f012(is1,is0) return band(is1,item.flags)~=0 and 1 or band(is0,item.flags)~=0 and 0 or 2 end
--
local Form = {-- диалог редактирования макроса
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76,17,0,0,0,0,item.needsave and L.diEdit.KeyMacroUnsHdr or L.diEdit.KeyMacroHdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diEdit.Area:sub(4)},
--[[03]] {F.DI_TEXT,       19, 2,0, 2,0,0,0,0,item.area},
--[[04]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diEdit.Key:sub(4)},
--[[05]] {F.DI_TEXT,       19, 3,0, 3,0,0,0,0,item.key},
--[[06]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diEdit.Desc},
--[[07]] {F.DI_EDIT,       19, 4,74, 4,0,"MacroDescription",0,F.DIF_HISTORY,item.description or ""},
--[[08]] {F.DI_TEXT,       -1, 5, 0, 5,0,0,0,F.DIF_SEPARATOR,""},
--[[09]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0,L.diEdit.FlagsHdr},
--[[10]] {F.DI_CHECKBOX,    5, 6, 0, 6,f01(0x1),0,0,0,L.diEdit.Flags.Output}, -- "EnableOutput"
--[[11]] {F.DI_CHECKBOX,    5, 7, 0, 7,f01(0x8),0,0,0,L.diEdit.Flags.OnStart}, -- "RunAfterFarStart"
--[[12]] {F.DI_CHECKBOX,   41, 7, 0, 7,f012(0x10,0x20),0,0,F.DIF_3STATE,L.diEdit.Flags.EmptyCS}, -- "NotEmptyCommandLine" or "EmptyCommandLine"
--[[13]] {F.DI_CHECKBOX,    5, 8, 0, 8,f01(0x2),0,0,0,L.diEdit.Flags.Keys}, -- "NoSendKeysToPlugins"
--[[14]] {F.DI_CHECKBOX,   41, 8, 0, 8,f012(0x40,0x80),0,0,F.DIF_3STATE,L.diEdit.Flags.Sel}, -- "NoEVSelection" or "EVSelection"
--[[15]] {F.DI_TEXT,        5, 9, 0, 9,0,0,0,0,L.diEdit.Flags.Act},
--[[16]] {F.DI_CHECKBOX,    6,10, 0,10,f012(0x1000,0x4000),0,0,F.DIF_3STATE,L.diEdit.Flags.PlugFile}, -- "NoFilePanels" or "NoPluginPanels"
--[[17]] {F.DI_CHECKBOX,    6,11, 0,11,f012(0x10000,0x40000),0,0,F.DIF_3STATE,L.diEdit.Flags.FolFile}, -- "NoFiles" or "NoFolders"
--[[18]] {F.DI_CHECKBOX,    6,12, 0,12,f012(0x100,0x400),0,0,F.DIF_3STATE,L.diEdit.Flags.FileSel}, -- "NoSelection" or "Selection"
--[[19]] {F.DI_TEXT,       40, 9, 0, 9,0,0,0,0,L.diEdit.Flags.Pass},
--[[20]] {F.DI_CHECKBOX,   41,10, 0,10,f012(0x2000,0x8000),0,0,F.DIF_3STATE,L.diEdit.Flags.PlugFile}, -- "NoFilePPanels" or "NoPluginPPanels"
--[[21]] {F.DI_CHECKBOX,   41,11, 0,11,f012(0x20000,0x80000),0,0,F.DIF_3STATE,L.diEdit.Flags.FolFile}, -- "NoPFiles" or "NoPFolders"
--[[22]] {F.DI_CHECKBOX,   41,12, 0,12,f012(0x200,0x800),0,0,F.DIF_3STATE,L.diEdit.Flags.FileSel}, -- "NoPSelection" or "PSelection"
--[[23]] {F.DI_TEXT,       -1,13, 0,13,0,0,0,F.DIF_SEPARATOR,""},
--[[24]] {F.DI_TEXT,        5,13, 0,13,0,0,0,0,L.diEdit.MCode},
--[[25]] {F.DI_EDIT,        5,14,74,14,0,"MacroCode",0,F.DIF_HISTORY,item.code},
--[[26]] {F.DI_TEXT,       -1,15, 0,15,0,0,0,F.DIF_SEPARATOR,""},
--[[27]] {F.DI_BUTTON,      0,16, 0,16,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[28]] {F.DI_BUTTON,      0,16, 0,16,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
-- начало кода функции
if not item.needsave and not (item.FileName and win.GetFileAttr(item.FileName)) then
  return false,L.KeyMacro.." "..item.descr..". "..L.er.NoFile
end
if far.Dialog(Guids.KeyMacroEdit,-1,-1,80,19,nil,Form,nil,DlgProc)~=27 then return true end -- выполним диалог; не "ОК" - уйдём
local flags = (Form[10][6]==1 and " EnableOutput" or "").. -- сформируем новые флаги
  (Form[11][6]==1 and " RunAfterFARStart" or "")..
  (Form[12][6]==0 and " NotEmptyCommandLine" or "")..(Form[12][6]==1 and " EmptyCommandLine" or "")..
  (Form[13][6]==1 and " NoSendKeysToPlugins" or "")..
  (Form[14][6]==0 and " NoEVSelection" or "")..(Form[14][6]==1 and " EVSelection" or "")..
  (Form[16][6]==0 and " NoPluginPanels" or "")..(Form[16][6]==1 and " NoFilePanels" or "")..
  (Form[17][6]==0 and " NoFolders" or "")..(Form[17][6]==1 and " NoFiles" or "")..
  (Form[18][6]==0 and " NoSelection" or "")..(Form[18][6]==1 and " Selection" or "")..
  (Form[20][6]==0 and " NoPluginPPanels" or "")..(Form[20][6]==1 and " NoFilePPanels" or "")..
  (Form[21][6]==0 and " NoPFolders" or "")..(Form[21][6]==1 and " NoPFiles" or "")..
  (Form[22][6]==0 and " NoPSelection" or "")..(Form[22][6]==1 and " PSelection" or "")
local text = ('Macro{\narea=%q;\nkey=%q;\nflags=%q;\ndescription=%q;\ncode=%q;\n}\n'):format(item.area,item.key,flags:sub(2),Form[7][10],Form[25][10])
Write(item.FileName,text) -- запишем новый вариант в файл
return far.MacroLoadAll(),L.er.EKeyMacro -- обновим макросы в Farе
end
-- +
--[==[Редактирование обработчика событий в диалоге]==]
-- -
function OpenEventInDialog(item,new,noreload)
--
local ov,cond,act,cbody,abody,CurrElem,defca,D
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_BTNCLICK and Param1==4 then -- нажали кнопку генерация uid?
  hDlg:send(F.DM_SETTEXT,Param1-1,GenUid()) -- сгенерируем и запишем
elseif Msg == F.DN_EDITCHANGE and Param1==6 then -- изменение поля description?
  local s = hDlg:send(F.DM_GETTEXT,Param1)
  item.descr = (s~="") and "'"..s.."'" or item.index and "index="..item.index or "NewEvent"
elseif Msg == F.DN_EDITCHANGE and Param1==8 then -- изменение поля группа?
  hDlg:send(F.DM_SETTEXT,Param1,Param2[10]:match("(%w*):.*")) -- запишем без комментария
  local EV = IsEV:find(Param2[10]) -- группа - редактора или просмотрщика?
  hDlg:send(F.DM_ENABLE,12,EV) -- для редактора и просмотрщика разрешим ввод маски файла
  if not EV then hDlg:send(F.DM_SETTEXT,12,"") end -- для остальных очистим маску файла
elseif Msg==F.DN_KILLFOCUS and Param1==10 then -- уход с элемента изменение приоритета?
  local nv = tonumber(hDlg:send(F.DM_GETTEXT,Param1)) -- новое значение
  if not nv or nv>100 or nv<0 then hDlg:send(F.DM_SETTEXT,Param1,ov) end -- плохое - откатим
elseif Msg==F.DN_DRAWDLGITEM and(Param1==15 or Param1==19) then -- рисуем вручную condition или action
  FillUserControl(hDlg,Param2,Param1==15 and cond or act,CurrElem==Param1) -- заполним
elseif Msg==F.DN_CONTROLINPUT and (Param1==15 or Param1==19) then -- ввод в condition или action?
  if (Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1f)==0)or(Param2.EventFlags==F.DOUBLE_CLICK) then -- F4/DblClick
    local grp,t = (hDlg:send(F.DM_GETTEXT,8)) -- получим текущее значение группы событий
    t = EditFun(Param1==15 and cond or act,Param1==15 and "Cond" or "ECode",Param1==15 and defca[grp].c or defca[grp].a,hDlg,item) -- поредактируем
    if Param1==15 then cond = t else act = t end -- запишем результат куда надо
    hDlg:send(F.DM_REDRAW) -- обновим диалог
  end
elseif Msg==F.DN_BTNCLICK and(Param1==16 or Param1==20) then -- нажали кнопку редактировать функцию?
  local grp = hDlg:send(F.DM_GETTEXT,8) -- получим текущее значение группы событий
  if Param1==16 then local t = EditFun(cbody or cond,"CondBody",defca[grp].c,hDlg,item) if cbody then cbody = t else cond = t end
  else local t = EditFun(abody or act,"CodeBody",defca[grp].a,hDlg,item) if abody then abody = t else act = t end end -- поредактируем и запишем
  hDlg:send(F.DM_REDRAW) -- обновим изображение
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0 then -- нажатие F1
  ShowHelp("edit")
elseif Msg==F.DN_GOTFOCUS then -- переход на элемент
  CurrElem = Param1 -- запомним текущий элемент
  if Param1==10 then -- изменение приоритета?
    ov = hDlg:send(F.DM_GETTEXT,Param1) -- запомним старое значение
  end
elseif Msg==F.DN_CLOSE then -- закрытие диалога?
  hDlg:send(F.DM_SETFOCUS,6) -- переключимся на description
end
end
-- начало кода функции
if not (item.FileName and win.GetFileAttr(item.FileName)) then
  return false,L.Macro.." "..item.descr..". "..L.er.NoFile
end
if new then cond,act,D = "","",{smoon=item.FileName:lower():match("%.moon$"),spfx="",src={}} -- новый обработчик событий - сделаем заглушки
else
  D = PrepareFiles(item) -- достанем всё
  if not D.sbody then -- скрипт не найден?
    if far.Message(L.Event.." "..item.descr..L.er.NotFound..".\n"..L.edEditEvent.."?",nfo.name,";OkCancel")==1 then
      return OpenInEditor(item) else return false,L.Event.." "..item.descr..L.er.NotFound end
  end
  if D.c.name then cond,cbody = D.c.name,D.c.body else cond = D.c.body end
  if D.a.name then act,abody = D.a.name,D.a.body else act = D.a.body end
end
--
local Y = cond and math.floor((Far.Height+2)/2) or 18 -- начало action
local Form = { -- диалог редактирования обработчика событий
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76,Far.Height-2,0,0,0,0,L.diEdit.EventHdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diEdit.id},
--[[03]] {F.DI_EDIT,       22, 2,58, 2,0,"",0,0,item.id or D.src.uid or GenUid()},
--[[04]] {F.DI_BUTTON,     60, 2, 0, 2,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.GenUid},
--[[05]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diEdit.Desc},
--[[06]] {F.DI_EDIT,       22, 3,74, 3,0,"EventDescription",0,F.DIF_HISTORY,item.description or ""},
--[[07]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diEdit.Group},
--[[08]] {F.DI_COMBOBOX,   22, 4,74, 4,L.cbEventsList,0,0,F.DIF_DROPDOWNLIST,item.group},
--[[09]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0, L.diEdit.Prio},
--[[10]] {F.DI_EDIT,       22, 5,25, 5,0,0,0,0,item.priority or 50},
--[[11]] {F.DI_TEXT,       27, 5, 0, 5,0,0,0,0,L.diEdit.Mask},
--[[12]] {F.DI_EDIT,       41, 5,74, 5,0,"EventFileMask",0,F.DIF_HISTORY+(IsEV:find(item.group) and 0 or F.DIF_DISABLE),item.filemask or ""},
--[[13]] {F.DI_TEXT,       -1, 6, 0, 6,0,0,0,F.DIF_SEPARATOR,""},
--[[14]] {F.DI_TEXT,        5, 6, 0, 6,0,0,0,0,L.diEdit.Cond..L.diEdit.F4},
--[[15]] cond
     and {F.DI_USERCONTROL, 5, 7,74,Y-1,0}
      or {F.DI_TEXT,        5, 7,74, 7,0,0,0,0,L.diEdit.CondNotInFile1},
--[[16]] cond
     and (cbody -- тело внутри - отдельных кнопок не надо
     and {F.DI_BUTTON,     40, 6, 0, 6,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.CondBody}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""})
      or {F.DI_TEXT,        5, 8,74, 8,0,0,0,0,L.diEdit.CondNotInFile2},
--[[17]] {F.DI_TEXT,       -1, Y, 0, Y,0,0,0,F.DIF_SEPARATOR,""},
--[[18]] {F.DI_TEXT,        5, Y, 0, Y,0,0,0,0,L.diEdit.ECode..L.diEdit.F4},
--[[19]] act
     and {F.DI_USERCONTROL, 5,Y+1,74,Far.Height-5,0}
      or {F.DI_TEXT,        5,Y+1,74,Y+1,0,0,0,0,L.diEdit.CodeNotInFile1},
--[[20]] act
     and (abody -- тело внутри - отдельных кнопок не надо
     and {F.DI_BUTTON,     40, Y, 0, Y,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.CodeBody}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""})
      or {F.DI_TEXT,        5,Y+2,74,Y+2,0,0,0,0,L.diEdit.CodeNotInFile2},
--[[21]] {F.DI_TEXT,       -1,Far.Height-4, 0,Far.Height-4,0,0,0,F.DIF_SEPARATOR,""},
--[[22]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[23]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
defca = Templates.Event[D.smoon and "moon" or "lua"] -- пустые condition и action
repeat
local errs = ""
  if far.Dialog(Guids.EventEdit,-1,-1,80,Far.Height,nil,Form,nil,DlgProc)~=22 then return true end -- не "ок" - уйдём
  if Form[8][10]=="" then errs = errs..L.er.NoGroup end -- нет группы? Ошибка
  if act=="" then errs = errs..L.er.NoCode end -- нет обработчика? Ошибка
until errs=="" or far.Message(L.Event..L.er.NoPart..errs,L.diEdit.EventHdr,L.er.NoPartKeys)==1 -- повторяем, если не устраивает
if Form[3][10]=="" then Form[3][10] = GenUid() end -- нет id/uid? тут мы можем поправить автоматом
local e = D.smoon and ((new and "\n" or "")..[[
%sEvent
%s  id:%q
%s  group:%q
%s%s  description:%q
%s%s  filemask:%q
%s%s  priority:%s
%s%s  condition:%s
%s%s  action:%s
]]):format(D.spfx,D.spfx,Form[3][10],D.spfx,Form[8][10],Form[6][10]=="" and "--" or "",D.spfx,Form[6][10],
    Form[12][10]=="" and "--" or "",D.spfx,Form[12][10],Form[10][10]=="50" and "--" or "",D.spfx,Form[10][10],
    cond=="" and "--" or "",D.spfx,cond=="" and defca[Form[8][10]].c or cond,act=="" and "--" or "",D.spfx,act=="" and defca[Form[8][10]].a or act)
                   or ((new and "\n" or "")..[[
Event{
  id=%q;
  group=%q;
%s  description=%q;
%s  filemask=%q;
%s  priority=%s;
%s  condition=%s
%s  action=%s
}
]]):format(Form[3][10],Form[8][10],Form[6][10]=="" and "--" or "",Form[6][10],Form[12][10]=="" and "--" or "",Form[12][10],
    Form[10][10]=="50" and "--" or "",Form[10][10],cond=="" and "--" or "",cond=="" and defca[Form[8][10]].c:gsub("end","end;",1) or cond..";",
    act=="" and "--" or "",act=="" and defca[Form[8][10]].a:gsub("end","end;",1) or act..";")
if new then Write(item.FileName,e) else Replace(item.FileName,D.sbody,e) end -- запишем новый вариант в файл
if cbody and D.c.file then Replace(D.c.file,D.c.body,cbody) end -- запишем новый текст функции condition в файл
if abody and D.a.file then Replace(D.a.file,D.a.body,abody) end -- запишем новый текст функции action в файл
return new or noreload or far.MacroLoadAll(),L.er.EEvent -- обновим макросы в Farе
end
-- +
--[==[Редактирование пункта меню плагинов в диалоге]==]
-- -
function OpenMenuItemInDialog(item,new,noreload)
--
local D,textf,act,tbody,abody,CurrElem,defta
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_BTNCLICK and Param1==4 then -- нажата кнопка генерация guid?
  hDlg:send(F.DM_SETTEXT,Param1-1,GenUid()) -- сгенерируем и запишем
elseif Msg==F.DN_EDITCHANGE and Param1==6 then -- изменилось содержимое поля ввода description?
  local s = hDlg:send(F.DM_GETTEXT,Param1)
  item.descr = (s~="") and "'"..s.."'" or item.index and "index="..item.index or "NewMenuItem"
elseif Msg==F.DN_BTNCLICK and Param1==9 then -- нажата кнопка выбор области из списка?
  local areas,ok = SetFilter(hDlg:send(F.DM_GETTEXT,Param1-1),L.AreaItems) -- выберем
  if ok then hDlg:send(F.DM_SETTEXT,Param1-1,areas) end -- запишем
elseif Msg==F.DN_DRAWDLGITEM and ((Param1==16 and type(item.text)~="string") or Param1==20) then -- рисуем вручную
  FillUserControl(hDlg,Param2,Param1==16 and (textf or "\n") or act,CurrElem==Param1) -- нарисуем
elseif Msg==F.DN_CONTROLINPUT and((Param1==16 and type(item.text)=="function") or Param1==20) then -- что-то нажали в поле функции?
  if (Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1f)==0)or(Param2.EventFlags==F.DOUBLE_CLICK) then -- F4/DblClick
    local t = EditFun(Param1==16 and textf or act,Param1==16 and "Text" or "MICode",Param1==16 and defta.t or defta.a,hDlg,item) -- ОК
    if Param1==16 then textf = t else act = t end -- запишем, куда надо
    hDlg:send(F.DM_REDRAW) -- обновим экран
  end
elseif Msg==F.DN_BTNCLICK and (Param1==17 or Param1==21) then -- нажата кнопка редактировать функцию?
  local t = EditFun(Param1==17 and(tbody or textf)or(abody or act),Param1==17 and"TextBody"or"CodeBody",Param1==17 and defta.t or defta.a,hDlg,item)
  if Param1==17 then if tbody then tbody = t else textf = t end -- text?
  else if abody then abody = t else act = t end end -- action; запишем, куда надо
  hDlg:send(F.DM_REDRAW) -- обновим диалог
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0 then -- нажатие F1
  ShowHelp("edit")
elseif Msg==F.DN_GOTFOCUS then -- переход на элемент?
  CurrElem = Param1 -- запомним текущий элемент
elseif Msg==F.DN_CLOSE then -- закрываем диалог?
  hDlg:send(F.DM_SETFOCUS,8) -- переключимся на checkbox
end
end
-- начало кода функции
if not (item.FileName and win.GetFileAttr(item.FileName)) then
  return false,L.MenuItem.." "..item.descr..". "..L.er.NoFile
end
if new then textf,act,D = "","",{smoon = item.FileName:lower():match("%.moon$"),spfx = ""} -- новый пункт меню - сделаем заглушки
else
  D = PrepareFiles(item) -- достанем всё
  if not D.sbody then -- скрипт не найден?
    if far.Message(L.MenuItem.." "..item.descr..L.er.NotFound..".\n"..L.edEditMenuItem.."?",nfo.name,";OkCancel")==1 then
      return OpenInEditor(item) else return false,L.MenuItem.." "..item.descr..L.er.NotFound end
  end
  if D.t.name then textf,tbody = D.t.name,D.t.body else textf = D.t.body end
  if D.a.name then act,abody = D.a.name,D.a.body else act = D.a.body end
end
if not item.area then item.area = "" for n,a in pairs(Areas) do if item.flags[n] then item.area = (item.area.." "..a):gsub("^ ","") end end end
--
local Y = type(item.text)~="string" and math.floor((Far.Height+2)/2) or 8 -- начало action
local Form = {-- диалог редактирования пункта меню
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76, Far.Height-2,0,0,0,0,L.diEdit.MenuItemHdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diEdit.Guid},
--[[03]] {F.DI_EDIT,       19, 2,58, 2,0,"",0,0,win.Uuid(item.guid):upper()},
--[[04]] {F.DI_BUTTON,     60, 2, 0, 2,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.GenUid},
--[[05]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diEdit.Desc},
--[[06]] {F.DI_EDIT,       19, 3,74, 3,0,"MenuItemDescription",0,F.DIF_HISTORY,item.description},
--[[07]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diEdit.Area},
--[[08]] {F.DI_EDIT,       19, 4,61, 4,0,"",0,0,item.area},
--[[09]] {F.DI_BUTTON,     63, 4, 0, 4,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.Sel},
--[[10]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0,L.diEdit.PlugMenu},
--[[11]] {F.DI_CHECKBOX,   19, 5, 0, 5,item.flags.plugins and 1 or 0,0,0,0,"Plugins"},
--[[12]] {F.DI_CHECKBOX,   39, 5, 0, 5,item.flags.disks and 1 or 0,0,0,0,"Disks"},
--[[13]] {F.DI_CHECKBOX,   59, 5, 0, 5,item.flags.config and 1 or 0,0,0,0,"Config"},
--[[14]] {F.DI_TEXT,       -1, 6, 0, 6,0,0,0,F.DIF_SEPARATOR,""},
--[[15]] {F.DI_TEXT,        5, 6, 0, 6,0,0,0,0,L.diEdit.Text..(type(item.text)~="string" and L.diEdit.F4 or "")},
--[[16]] type(item.text)=="string"
     and {F.DI_EDIT,        5, 7,74, 7,0,"",0,0,item.text}
      or {F.DI_USERCONTROL, 5, 7,74,Y-1,0},
--[[17]] type(item.text)=="function" and tbody
     and {F.DI_BUTTON,     40, 6, 0, 6,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.TextBody}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""},
--[[18]] {F.DI_TEXT,       -1, Y, 0, Y,0,0,0,F.DIF_SEPARATOR,""},
--[[19]] {F.DI_TEXT,        5, Y, 0, Y,0,0,0,0,L.diEdit.MICode..L.diEdit.F4},
--[[20]] act
     and {F.DI_USERCONTROL, 5,Y+1,74,Far.Height-5,0}
      or {F.DI_TEXT,        5,Y+1, 0,Y+1,0,0,0,0,L.diEdit.CodeNotInFile1},
--[[21]] act
     and (abody
     and {F.DI_BUTTON,     40, Y, 0, Y,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.CodeBody}
      or {F.DI_TEXT,        1, 1, 1, 1,0,0,0,0,""})
      or {F.DI_TEXT,        5,Y+2, 0,Y+2,0,0,0,0,L.diEdit.CodeNotInFile2},
--[[22]] {F.DI_TEXT,       -1,Far.Height-4, 0,Far.Height-4,0,0,0,F.DIF_SEPARATOR,""},
--[[23]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[24]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
defta = Templates.MenuItem[D.smoon and "moon" or "lua"] -- пустые condition и action
repeat
local errs = ""
  if far.Dialog(Guids.MacroEdit,-1,-1,80,Far.Height,nil,Form,nil,DlgProc)~=23 then return true end -- не "ОК" - уйдём
  if act=="" then errs = errs..L.er.NoCode end -- нет обработчика? Ошибка
until errs=="" or far.Message(L.Macro..L.er.NoPart..errs,L.diEdit.MacroHdr,L.er.NoPartKeys)==1 -- повторяем, если не устраивает
if Form[3][10]=="" then Form[3][10] = GenUid() end -- нет guid? тут мы можем поправить автоматом
local menu = ((Form[11][6]==1 and " Plugins" or "")..(Form[12][6]==1 and " Disks" or "")..(Form[13][6]==1 and " Config" or "")):sub(2)
textf = type(item.text)=="string" and '"'..Form[16][10]..'"' or ((not textf or textf=="") and defta.t or textf)
local m = D.smoon and ((new and "\n" or "")..[[
%sMenuItem
%s  guid:%q
%s  menu:%q
%s  area:%q
%s%s  description:%q
%s  text:%s
%s%s  action:%s
]]):format(D.spfx,D.spfx,Form[3][10],D.spfx,menu,D.spfx,Form[8][10],Form[6][10]=="" and "--" or "",D.spfx,Form[6][10],
    D.spfx,textf,act=="" and "--" or "",D.spfx,act=="" and defta.a or act)
                   or ((new and "\n" or "")..[[
MenuItem{
  guid=%q;
  menu=%q;
%s  area=%q;
%s  description=%q;
  text=%s;
%s  action=%s;
}
]]):format(Form[3][10],menu,Form[8][10]=="" and "--" or "",Form[8][10],Form[6][10]=="" and "--" or "",Form[6][10],
    textf,act=="" and "--" or "",act=="" and defta.a or act)
if new then Write(item.FileName,m) else Replace(item.FileName,D.sbody,m) end -- запишем новый вариант в файл
if tbody and D.t.file then Replace(D.t.file,D.t.body,tbody) end -- запишем новый текст функции text в файл
if abody and D.a.file then Replace(D.a.file,D.a.body,abody) end -- запишем новый текст функции action в файл
return new or noreload or far.MacroLoadAll(),L.er.EMenuItem -- обновим макросы в Farе
end
-- +
--[==[Редактирование префикса командной строки в диалоге]==]
-- -
function OpenPrefixInDialog(item,new,noreload)
--
local act,abody,CurrElem,defa,D
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_DRAWDLGITEM and Param1==08 then -- рисуем вручную
    FillUserControl(hDlg,Param2,act,CurrElem==Param1) -- нарисуем
elseif Msg==F.DN_CONTROLINPUT and Param1==08 and
  ((Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1f)==0)or(Param2.EventFlags==F.DOUBLE_CLICK)) then -- F4/DblClick в поле action?
  act = EditFun(act,"PCode",defa.a,hDlg,item) -- ОК
  hDlg:send(F.DM_REDRAW) -- обновим экран
elseif Msg==F.DN_BTNCLICK and Param1==09 then -- нажата кнопка редактировать функцию?
  local t = EditFun(abody or act,"CodeBody",defa.a,hDlg,item) -- поредактируем
  if abody then abody = t else act = t end -- запишем, куда надо
  hDlg:send(F.DM_REDRAW) -- обновим диалог
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0 then -- нажатие F1
  ShowHelp("edit")
elseif Msg==F.DN_GOTFOCUS then -- переход на элемент?
  CurrElem = Param1 -- запомним текущий элемент
elseif Msg==F.DN_CLOSE then -- закрываем диалог?
  hDlg:send(F.DM_SETFOCUS,3) -- переключимся на description
end
end
-- начало кода функции
if not (item.FileName and win.GetFileAttr(item.FileName)) then
  return false,L.CommandLine.." "..item.description..". "..L.er.NoFile
end
if new then act,D = "",{smoon = item.FileName:lower():match("%.moon$"),spfx = ""} -- новый префикс - сделаем заглушки
else
  D = PrepareFiles(item) -- достанем всё
  if not D.sbody then -- префикс не найден?
    if far.Message(L.CommandLine.." "..item.description..L.er.NotFound..".\n"..L.edEditCommandLine.."?",nfo.name,";OkCancel")==1 then
      return OpenInEditor(item) else return false,L.CommandLine.." "..item.description..L.er.NotFound end
  end
  if D.a.name then act,abody = D.a.name,D.a.body else act = D.a.body end
end
--
local Form = {-- диалог редактирования префикса
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76,Far.Height-2,0,0,0,0,L.diEdit.PrefixHdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diEdit.Desc},
--[[03]] {F.DI_EDIT,       19, 2,74, 2,0,"PrefixDescription",0,F.DIF_HISTORY,item.description},
--[[04]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diEdit.Prefix},
--[[05]] {F.DI_EDIT,       19, 3,74, 3,0,0,0,0,item.prefixes},
--[[06]] {F.DI_TEXT,       -1, 4, 0, 4,0,0,0,F.DIF_SEPARATOR,""},
--[[07]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diEdit.PCode..L.diEdit.F4},
--[[08]] act
     and {F.DI_USERCONTROL, 5, 5,74, Far.Height-5,0}
      or {F.DI_TEXT,5,17,0,0,0,0,0,0,L.diEdit.CodeNotInFile1},
--[[09]] act
     and (abody -- тело внутри - отдельных кнопок не надо
     and {F.DI_BUTTON,     40, 4, 0, 4,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.CodeBody}
      or {F.DI_TEXT,1,1,1,1,0,0,0,0,""})
      or {F.DI_TEXT,5,18,0,0,0,0,0,0,L.diEdit.CodeNotInFile2},
--[[10]] {F.DI_TEXT,       -1,Far.Height-4, 0,Far.Height-4,0,0,0,F.DIF_SEPARATOR,""},
--[[11]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[12]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
defa = Templates.CommandLine[D.smoon and "moon" or "lua"] -- пустые condition и action
repeat
local errs = ""
  if far.Dialog(Guids.PrefixEdit,-1,-1,80,Far.Height,nil,Form,nil,DlgProc)~=11 then return true end -- не "ОК" - уйдём
  if Form[5][10]=="" then errs = errs..L.er.NoPrefix end -- нет префикса? Ошибка
  if act=="" then errs = errs..L.er.NoCode end -- нет обработчика? Ошибка
until errs=="" or far.Message(L.CommandLine..L.er.NoPart..errs,L.diEdit.PrefixHdr,L.er.NoPartKeys)==1 -- повторяем, если не устраивает
local p = D.smoon and ((new and "\n" or "")..[[
%sCommandLine
%s  prefixes:%q
%s%s  description:%q
%s%s  action:%s
]]):format(D.spfx,D.spfx,Form[5][10],Form[3][10]=="" and "--" or "",D.spfx,Form[3][10],act=="" and "--" or "",D.spfx,act=="" and defa.a or act)
                   or ((new and "\n" or "")..[[
CommandLine{
  prefixes=%q;
%s  description=%q;
%s  action=%s;
}
]]):format(Form[5][10],Form[3][10]=="" and "--" or "",Form[3][10],act=="" and "--" or "",act=="" and defa.a or act) -- новый текст префикса
if new then Write(item.FileName,p) else Replace(item.FileName,D.sbody,p) end -- запишем новый вариант в файл
if abody and D.a.file then Replace(D.a.file,D.a.body,abody) end -- запишем новый текст функции action в файл
return new or noreload or far.MacroLoadAll(),L.er.ECommandLine -- обновим макросы в Farе
end
-- +
--[==[Редактирование панельного модуля в диалоге]==]
-- -
function OpenPanelModuleInDialog(item,new,noreload)
--
local fun,funname,fbody,CurrElem,deff,D = {},"",{},2
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_BTNCLICK and Param1==4 then -- нажали кнопку генерация uid?
  hDlg:send(F.DM_SETTEXT,Param1-1,GenUid()) -- сгенерируем и запишем
elseif Msg == F.DN_EDITCHANGE and (Param1==6 or Param1==8)then -- изменение поля Description или Title?
  local d,t = hDlg:send(F.DM_GETTEXT,6),hDlg:send(F.DM_GETTEXT,8)
  item.descr = ((t~="") and "'"..t.."'") or ((d~="") and "'"..d.."'") or Noid
elseif Msg == F.DN_EDITCHANGE and Param1==15 then -- выбрали другую функцию?
  funname = Param2[10]:match("^.(.-):.*$"):gsub("&","") -- извлечём имя функции
  hDlg:send(F.DM_ENABLE,19,fun[funname] and 1 or 0) -- разрешим/запретим текст функции
  hDlg:send(F.DM_ENABLE,20,fbody[funname] and 1 or 0) -- разрешим/запретим кнопку функции
elseif Msg==F.DN_DRAWDLGITEM and Param1==19 then -- рисуем вручную
  if hDlg:send(F.DM_ENABLE,Param1,-1)==1 then FillUserControl(hDlg,Param2,fun[funname],CurrElem==Param1) end -- нарисуем
elseif Msg==F.DN_CONTROLINPUT and Param1==19 and
  ((Param2.VirtualKeyCode==0x73 and band(Param2.ControlKeyState,0x1f)==0)or(Param2.EventFlags==F.DOUBLE_CLICK)) then -- F4/DblClick в поле action?
  fun[funname] = EditFun(fun[funname],"FCode",deff[funname],hDlg,item,"("..funname..")") -- ОК
  local s = ((fun[funname] and fun[funname]~="") and "+" or "-")..hDlg:send(F.DM_GETTEXT,15):sub(2) -- скорректируем строку из ComboBox
  hDlg:send(F.DM_LISTUPDATE,15,{Index=hDlg:send(F.DM_LISTGETCURPOS,15).SelectPos,Text=s,Flags=F.LIF_SELECTED}) -- поправим ComboBox
elseif Msg==F.DN_BTNCLICK and Param1==20 then -- нажата кнопка редактировать функцию?
  local t = EditFun(fbody[funname] or fun[funname],"FunBody",deff[funname],hDlg,item,"("..funname..")") -- поредактируем
  if fbody[funname] then fbody[funname] = t else fun[funname] = t end -- запишем, куда надо
  hDlg:send(F.DM_REDRAW) -- обновим диалог
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode==0x70 and band(Param2.ControlKeyState,0x1f)==0 then -- нажатие F1
  ShowHelp("edit")
elseif Msg==F.DN_GOTFOCUS then -- переход на элемент?
  CurrElem = Param1 -- запомним текущий элемент
elseif Msg==F.DN_CLOSE then -- закрываем диалог?
  hDlg:send(F.DM_SETFOCUS,6) -- переключимся на description
end
end
-- начало кода функции
if not (item.FileName and win.GetFileAttr(item.FileName)) then
  return false,L.PanelModule.." "..item.descr..". "..L.er.NoFile
end
if new then D = {smoon = item.FileName:lower():match("%.moon$"),spfx = ""} -- новый префикс - сделаем заглушки
else
  D = PrepareFiles(item) -- достанем всё
  if not D.sbody then -- префикс не найден?
    if far.Message(L.PanelModule.." "..item.descr..L.er.NotFound..".\n"..L.edEditPanelModule.."?",nfo.name,";OkCancel")==1 then
      return OpenInEditor(item) else return false,L.PanelModule.." "..item.descr..L.er.NotFound end
  end
end
for i,fn in ipairs(FuncNames) do
  if D[fn] and D[fn].name then fun[fn],fbody[fn] = D[fn].name,D[fn].body else fun[fn] = D[fn] and D[fn].body or "" end
  L.cbFunctionsList[i].Text = ((fun[fn] and fun[fn]~="") and "+" or "-")..L.cbFunctionsList[i].Text:sub(2)
end
--
local Form = {-- диалог редактирования панельного модуля
--[[01]] {F.DI_DOUBLEBOX,   3, 1,76,Far.Height-2,0,0,0,0,L.diEdit.PanelHdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diEdit.Guid},
--[[03]] {F.DI_EDIT,       19, 2,58, 2,0,"",0,0,win.Uuid(item.Info.Guid):upper()},
--[[04]] {F.DI_BUTTON,     60, 2, 0, 2,0,0,0,F.DIF_BTNNOCLOSE,L.diEdit.GenUid},
--[[05]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diEdit.Desc},
--[[06]] {F.DI_EDIT,       19, 3,74, 3,0,"PanelDescription",0,F.DIF_HISTORY,item.Info and item.Info.Description},
--[[07]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diEdit.Title},
--[[08]] {F.DI_EDIT,       19, 4,74, 4,0,"PanelTitle",0,F.DIF_HISTORY,item.Info and item.Info.Title},
--[[09]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0,L.diEdit.Version},
--[[10]] {F.DI_EDIT,       19, 5,74, 5,0,"PanelVersion",0,F.DIF_HISTORY,item.Info and item.Info.Version},
--[[11]] {F.DI_TEXT,        5, 6, 0, 6,0,0,0,0,L.diEdit.Author},
--[[12]] {F.DI_EDIT,       19, 6,74, 6,0,"PanelAuthor",0,F.DIF_HISTORY,item.Info and item.Info.Author},
--[[13]] {F.DI_TEXT,       -1, 7, 0, 7,0,0,0,F.DIF_SEPARATOR,""},
--[[14]] {F.DI_TEXT,        5, 8, 0, 8,0,0,0,0,L.diEdit.Func},
--[[15]] {F.DI_COMBOBOX,   16, 8,74, 8,L.cbFunctionsList,0,0,F.DIF_DROPDOWNLIST+F.DIF_LISTNOAMPERSAND,("-"):rep(74)},
--[[16]] {F.DI_TEXT,        5, 9, 0, 9,0,0,0,0,L.diEdit.FCode..L.diEdit.F4},
--[[17]] {F.DI_TEXT,        5,11, 0,11,0,0,0,0,L.diEdit.FunNotInFile1},
--[[18]] {F.DI_TEXT,        5,12, 0,12,0,0,0,0,L.diEdit.FunNotInFile2},
--[[19]] {F.DI_USERCONTROL, 5,10,74, Far.Height-5,0,F.DIF_DISABLE},
--[[20]] {F.DI_BUTTON,     40, 9, 0, 9,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_DISABLE,L.diEdit.FunBody},
--[[21]] {F.DI_TEXT,       -1,Far.Height-4, 0,Far.Height-4,0,0,0,F.DIF_SEPARATOR,""},
--[[22]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[23]] {F.DI_BUTTON,      0,Far.Height-3, 0,Far.Height-3,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
deff = Templates.PanelModule[D.smoon and "moon" or "lua"] -- пустые функции
repeat
local errs = ""
  if far.Dialog(Guids.PanelEdit,-1,-1,80,Far.Height,nil,Form,nil,DlgProc)~=22 then return true end -- не "ОК" - уйдём
  if Form[3][10]=="" then errs = errs..L.er.NoGuid end -- нет GUID? Ошибка
until errs=="" or far.Message(L.CommandLine..L.er.NoPart..errs,L.diEdit.PanelHdr,L.er.NoPartKeys)==1 -- повторяем, если не устраивает
local p = D.smoon and ((new and "\n" or "")..[[
%sPanelModule
%s  Info:
%s    Guid:win.Uuid %q
%s%s    Title:%q
%s%s    Description:%q
%s%s    Version:%q
%s%s    Author:%q
%s%s  Analyse:%s
%s%s  ClosePanel:%s
%s%s  Compare:%s
%s%s  DeleteFiles:%s
%s%s  GetFiles:%s
%s%s  GetFindData:%s
%s%s  GetOpenPanelInfo:%s
%s%s  MakeDirectory:%s
%s%s  Open:%s
%s%s  ProcessHostFile:%s
%s%s  ProcessPanelEvent:%s
%s%s  ProcessPanelInput:%s
%s%s  PutFiles:%s
%s%s  SetDirectory:%s
%s%s  SetFindList:%s
]]):format(D.spfx,D.spfx,D.spfx,Form[3][10],Form[8][10]=="" and "--" or "",D.spfx,Form[8][10],Form[6][10]=="" and "--" or "",D.spfx,Form[6][10],
  Form[10][10]=="" and "--" or "",D.spfx,Form[10][10],Form[12][10]=="" and "--" or "",D.spfx,Form[12][10],
  fun.Analyse=="" and "--" or "",D.spfx,fun.Analyse=="" and deff.Analyse:gsub("end","end;",1) or fun.Analyse,
  fun.ClosePanel=="" and "--" or "",D.spfx,fun.ClosePanel=="" and deff.ClosePanel:gsub("end","end;",1) or fun.ClosePanel,
  fun.Compare=="" and "--" or "",D.spfx,fun.Compare=="" and deff.Compare:gsub("end","end;",1) or fun.Compare,
  fun.DeleteFiles=="" and "--" or "",D.spfx,fun.DeleteFiles=="" and deff.DeleteFiles:gsub("end","end;",1) or fun.DeleteFiles,
  fun.GetFiles=="" and "--" or "",D.spfx,fun.GetFiles=="" and deff.GetFiles:gsub("end","end;",1) or fun.GetFiles,
  fun.GetFindData=="" and "--" or "",D.spfx,fun.GetFindData=="" and deff.GetFindData:gsub("end","end;",1) or fun.GetFindData,
  fun.GetOpenPanelInfo=="" and "--" or "",D.spfx,fun.GetOpenPanelInfo=="" and deff.GetOpenPanelInfo:gsub("end","end;",1) or fun.GetOpenPanelInfo,
  fun.MakeDirectory=="" and "--" or "",D.spfx,fun.MakeDirectory=="" and deff.MakeDirectory:gsub("end","end;",1) or fun.MakeDirectory,
  fun.Open=="" and "--" or "",D.spfx,fun.Open=="" and deff.Open:gsub("end","end;",1) or fun.Open,
  fun.ProcessHostFile=="" and "--" or "",D.spfx,fun.ProcessHostFile=="" and deff.ProcessHostFile:gsub("end","end;",1) or fun.ProcessHostFile,
  fun.ProcessPanelEvent=="" and "--" or "",D.spfx,fun.ProcessPanelEvent=="" and deff.ProcessPanelEvent:gsub("end","end;",1) or fun.ProcessPanelEvent,
  fun.ProcessPanelInput=="" and "--" or "",D.spfx,fun.ProcessPanelInput=="" and deff.ProcessPanelInput:gsub("end","end;",1) or fun.ProcessPanelInput,
  fun.PutFiles=="" and "--" or "",D.spfx,fun.PutFiles=="" and deff.PutFiles:gsub("end","end;",1) or fun.PutFiles,
  fun.SetDirectory=="" and "--" or "",D.spfx,fun.SetDirectory=="" and deff.SetDirectory:gsub("end","end;",1) or fun.SetDirectory,
  fun.SetFindList=="" and "--" or "",D.spfx,fun.SetFindList=="" and deff.SetFindList:gsub("end","end;",1) or fun.SetFindList)
                   or ((new and "\n" or "")..[[
PanelModule{
  Info={
    Guid=win.Uuid(%q);
%s    Title=%q;
%s    Description=%q;
%s    Version=%q;
%s    Author=%q;
  };
%s  Analyse=%s
%s  ClosePanel=%s
%s  Compare=%s
%s  DeleteFiles=%s
%s  GetFiles=%s
%s  GetFindData=%s
%s  GetOpenPanelInfo=%s
%s  MakeDirectory=%s
%s  Open=%s
%s  ProcessHostFile=%s
%s  ProcessPanelEvent=%s
%s  ProcessPanelInput=%s
%s  PutFiles=%s
%s  SetDirectory=%s
%s  SetFindList=%s
}
]]):format(Form[3][10],Form[8][10]=="" and "--" or "",Form[8][10],Form[6][10]=="" and "--" or "",Form[6][10],  -- новый текст панельного модуля
  Form[10][10]=="" and "--" or "",Form[10][10],Form[12][10]=="" and "--" or "",Form[12][10],
  fun.Analyse=="" and "--" or "",fun.Analyse=="" and deff.Analyse:gsub("end","end;",1) or fun.Analyse..";",
  fun.ClosePanel=="" and "--" or "",fun.ClosePanel=="" and deff.ClosePanel:gsub("end","end;",1) or fun.ClosePanel..";",
  fun.Compare=="" and "--" or "",fun.Compare=="" and deff.Compare:gsub("end","end;",1) or fun.Compare..";",
  fun.DeleteFiles=="" and "--" or "",fun.DeleteFiles=="" and deff.DeleteFiles:gsub("end","end;",1) or fun.DeleteFiles..";",
  fun.GetFiles=="" and "--" or "",fun.GetFiles=="" and deff.GetFiles:gsub("end","end;",1) or fun.GetFiles..";",
  fun.GetFindData=="" and "--" or "",fun.GetFindData=="" and deff.GetFindData:gsub("end","end;",1) or fun.GetFindData..";",
  fun.GetOpenPanelInfo=="" and "--" or "",fun.GetOpenPanelInfo=="" and deff.GetOpenPanelInfo:gsub("end","end;",1) or fun.GetOpenPanelInfo..";",
  fun.MakeDirectory=="" and "--" or "",fun.MakeDirectory=="" and deff.MakeDirectory:gsub("end","end;",1) or fun.MakeDirectory..";",
  fun.Open=="" and "--" or "",fun.Open=="" and deff.Open:gsub("end","end;",1) or fun.Open..";",
  fun.ProcessHostFile=="" and "--" or "",fun.ProcessHostFile=="" and deff.ProcessHostFile:gsub("end","end;",1) or fun.ProcessHostFile..";",
  fun.ProcessPanelEvent=="" and "--" or "",fun.ProcessPanelEvent=="" and deff.ProcessPanelEvent:gsub("end","end;",1) or fun.ProcessPanelEvent..";",
  fun.ProcessPanelInput=="" and "--" or "",fun.ProcessPanelInput=="" and deff.ProcessPanelInput:gsub("end","end;",1) or fun.ProcessPanelInput..";",
  fun.PutFiles=="" and "--" or "",fun.PutFiles=="" and deff.PutFiles:gsub("end","end;",1) or fun.PutFiles..";",
  fun.SetDirectory=="" and "--" or "",fun.SetDirectory=="" and deff.SetDirectory:gsub("end","end;",1) or fun.SetDirectory..";",
  fun.SetFindList=="" and "--" or "",fun.SetFindList=="" and deff.SetFindList:gsub("end","end;",1) or fun.SetFindList..";")
if new then Write(item.FileName,p) else Replace(item.FileName,D.sbody,p) end -- запишем новый вариант в файл
for _,fn in ipairs(FuncNames) do if fbody[fn] and D[fn].file then Replace(D[fn].file,D[fn].body,fbody[fn]) end end -- запишем новый текст функций
return new or noreload or far.MacroLoadAll(),L.er.EPanelModule -- обновим макросы в Farе
end
-- +
--[==[Редактирование скрипта в редакторе Farа]==]
-- -
function OpenInEditor(item,nonmodal)
local D,fn,fm = PrepareFiles(item),item.realname or item.FileName,nonmodal and F.EF_NONMODAL or nil -- данные, настоящее имя, флаг модальности
if not (fn and win.GetFileAttr(fn)) then return false,(L[D.stype]).." "..(item.descr or item.name or item.prefix or "?")..". "..L.er.NoFile end
local text1,err = Read(fn) -- получим всё старое содержимое файла
if err then return false,err end -- ошибка при чтении? уйдём
editor.Editor(fn,nil,nil,nil,nil,nil,fm,D.sstarty or 1,D.sstartx or 1) -- поредактируем
local text2 = Read(item.realname or item.FileName) -- получим всё новое содержимое файла
return text1==text2 or far.MacroLoadAll(),L.er["E"..D.stype] -- обновим в Farе, если содержимое файла изменилось
end
-- +
--[==[Создание нового элемента в файле с текущим]==]
-- -
function CreateNew(item)
if item.name then -- модуль?
    editor.Editor(item.realbase..os.tmpname():gsub("%.","_")..item.type) -- поредактируем новый
    return far.MacroLoadAll(),L.er.EModule -- обновим макросы в Farе
end
if item.code then return false,L.er.AddToKeyMacro end -- клавиатурные не создаём
local fname = item.FileName or GP.."\\Macros\\scripts"..os.tmpname()..".lua" -- имя файла, куда записывать
local text,err,newname = CreateAsText(item.FileName and item.FileName:match("%.%a*$"),fname)
if text and text~="" then Write(newname,text,"a") far.MacroLoadAll() end -- отредактировали без ошибок? допишем новый скрипт в конец файла
return not not text,err
end
-- +
--[==[Удаление макроса/обработчика событий под курсором]==]
-- -
function DeleteCurrent(item)
--
local function rem(PPI,fullname) -- удалить файл или каталог со всем содержимым
if (PPI and PPI.FileAttributes or win.GetFileAttr(fullname)):find("d") then -- каталог?
  far.RecursiveSearch(fullname,"*",rem) -- почистим его
  win.RemoveDir(fullname) -- и удалим
else -- файл
  win.DeleteFile(fullname) -- удалим
end
end
if not item.FileName then -- не из файла?
--!!! far.MacroDelete() требует id от far.MacroAdd()!!!
  return false,(L[GetType(item)]).." "..(item.descr or item.name or item.prefix)..". "..L.er.NoFile -- не удалить :(
end
if far.Message(L.DelElement.." "..(item.descr or item.name or item.prefix).."?",nfo.name,";OkCancel")~=1 then return true end -- отказ - молча уйдём
if item.code or item.name then rem(nil,item.FileName) return far.MacroLoadAll(),L.er.EKeyMacro end -- удалим клавиатурный огрызок или модуль; обновим
if not win.GetFileAttr(item.FileName) then return far.MacroLoadAll(),L.er.NoFile end -- файл потерялся? Просто обновим макросы в Farе
local D = PrepareFiles(item) -- достанем всё
if D.sbody then Replace(item.FileName,D.sbody,"") return far.MacroLoadAll(),L.er["E"..D.stype] end -- нашли тело скрипта - затрём; обновим скрипты
return false,L[D.stype].." "..(item.descr or item.prefix)..L.er[D.stype:sub(1,1).."NotFound"] -- не нашли...
end
-- +
--[==[Перепривязка клавиш]==]
-- -
function Rebind(item)
--
local function DlgProc(hDlg,Msg,Param1--[[,Param2--]]) -- обработка событий диалога
if Msg==F.DN_BTNCLICK then -- ввод клавиши
  if Param1==12 and item.rebinded then
    hDlg:send(F.DM_SETTEXT,16,item.rebinded)
  elseif Param1==17 then
    local key=MacroKey(hDlg)
    local keys=hDlg:send(F.DM_GETTEXT,16)
    keys = keys=="" and key or keys.." "..key
    hDlg:send(F.DM_SETTEXT,16,keys)
  end
end
end
--
local Form = { -- диалог настройки конфигурации
--[[01]] {F.DI_DOUBLEBOX,   3, 1,65,12,0,0,0,0,L.diRebind.Hdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diRebind.File},
--[[03]] {F.DI_TEXT,       20, 2, 0, 2,0,0,0,0,item.FileName},
--[[04]] {F.DI_TEXT,        5, 3, 0, 3,0,0,0,0,L.diRebind.Area},
--[[05]] {F.DI_TEXT,       20, 3, 0, 3,0,0,0,0,item.area},
--[[06]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diRebind[item.id]},
--[[07]] {F.DI_TEXT,       20, 4, 0, 4,0,0,0,0,item.id},
--[[08]] {F.DI_TEXT,        5, 5, 0, 5,0,0,0,0,L.diRebind.Desc},
--[[09]] {F.DI_TEXT,       20, 5, 0, 5,0,0,0,0,item.description or L.diRebind.Absent},
--[[10]] {F.DI_TEXT,        5, 6, 0, 6,0,0,0,0,L.diRebind.OldKey},
--[[11]] {F.DI_TEXT,       20, 6, 0, 6,0,0,0,0,item.rebinded or item.key},
--[[12]] {F.DI_BUTTON,     52, 6, 0, 6,0,0,0,F.DIF_BTNNOCLOSE,L.diRebind.ResetBtn},
--[[13]] {F.DI_TEXT,        5, 7, 0, 7,0,0,0,0,L.diRebind.Key},
--[[14]] {F.DI_TEXT,       20, 7, 0, 7,0,0,0,0,item.key},
--[[15]] {F.DI_TEXT,        5, 8, 0, 8,0,0,0,0,L.diRebind.NewKey},
--[[16]] {F.DI_EDIT,       20, 8,50, 8,0,"",0,0,item.key},
--[[17]] {F.DI_BUTTON,     52, 8, 0, 8,0,0,0,F.DIF_BTNNOCLOSE,L.diRebind.ChangeBtn},
--[[18]] {F.DI_TEXT,        5, 9, 0, 9,0,0,0,0,L.diRebind.Mask},
--[[19]] {F.DI_TEXT,       20, 9, 0, 9,0,0,0,0,item.filemask or L.diRebind.Absent},
--[[20]] {F.DI_TEXT,       -1,10, 0,10,0,0,0,F.DIF_SEPARATOR,""},
--[[21]] {F.DI_BUTTON,      0,11, 0,11,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.OK},
--[[22]] {F.DI_BUTTON,      0,11, 0,11,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
-- начало кода функции
if not item.area or item.guid or item.code then return true end -- обрабатываем только стационарные макросы
if not item.id then return false,L.er.NoId end
if far.Dialog(Guids.Rebind,-1,-1,69,14,nil,Form,nil,DlgProc)~=21 then return end -- вызовем диалог, не "ОК" - уйдём
if Form[16][10]==item.key then return end -- не изменилось - уйдём, как при отмене
local ok, err = rb.MacroRebind(item.id,Form[16][10]) -- перепривяжем
if not ok then return ok, err end -- ошибка - уйдём
return far.MacroLoadAll(),L.er.EMacro -- обновим макросы в Farе
end
-- +
--[==[Запретить/разрешить скрипт]==]
-- -
function Disable(item)
--
if item.code or item.guid or item.prefix or item.Info then return true end -- не обрабатываем клавиатурные макросы/пункты меню/префиксы/панели
if not (item.name or item.id) then return false,L.er.NoId end -- для всех, кроме модулей, нужен id/uid
if item.name then -- модуль?
  if item.FileName:sub(-OffExt:len())==OffExt then -- отключён?
    return win.RenameFile(item.FileName,item.FileName:sub(1,-1-OffExt:len())) -- включим
  else
    _G.package.loaded[item.name] = nil -- удалим из таблицы загруженных модулей
    return win.RenameFile(item.FileName,item.FileName..OffExt) -- отключим
  end
elseif rb then -- если не модуль, нужен rebind
  local _,err = rb.MacroDisable(item.id,not item.disabled) -- переключим состояние disabled
  return not err,err
end
end
-- +
--[==[Настройка конфигурации]==]
-- -
function Config()
--
local Filter,SO,OutOrder,Form,ov = {},{}
--
local function DlgProc(hDlg,Msg,Param1,Param2) -- обработка событий диалога
if Msg==F.DN_BTNCLICK then
  local tSO,tFilter = {[19]="Macro",[20]="Event",[21]="Module",[22]="MI",[23]="Prefix",[24]="PM"},{[31]="Area",[32]="Group",[33]="Path"}
  if tSO[Param1] then SO[tSO[Param1]] = SortingOrder(SO[tSO[Param1]],L["cb"..tSO[Param1].."SortVariants"]) -- сортировка макросов
  elseif tFilter[Param1] then Filter[tFilter[Param1]] = SetFilter(Filter[tFilter[Param1]],L[tFilter[Param1].."Items"]) -- выбор областей из списка
  elseif Param1==26 then -- сортировка вывода скриптов по типам
    local HotKeys,Types,OO,CurChar = {{BreakKey="RETURN"},{BreakKey="F1"},{BreakKey="C+UP"},{BreakKey="C+DOWN"},{BreakKey="C+NUMPAD8"},
      {BreakKey="C+NUMPAD2"}},{M=L.Mac,K=L.Key,E=L.Events,O=L.Modules,I=L.MenuItems,P=L.Prefixes,N=L.Panels},OutOrder,OutOrder:sub(1,1)
    repeat
      local items,pos,res = {}
      for c in OO:gmatch(".") do items[#items+1] = {text=Types[c],char=c} if c==CurChar then pos =  #items end end
      res,pos = far.Menu({Title=L.diConf.ShowOrder:gsub("&",""),Bottom="Enter,Esc,F1,CtrlUp/Down",SelectIndex=pos,Id=Guids.Sort},items,HotKeys)
      CurChar = items[pos] and items[pos].char
      if not res then break -- Esc? вернём старое значение
      elseif res.BreakKey=="RETURN" then OutOrder = OO break -- Enter? Вернём новое значение
      elseif res.BreakKey=="F1" then ShowHelp("sort")
      elseif pos>1 and(res.BreakKey=="C+UP" or res.BreakKey=="C+NUMPAD8") then -- поднять вверх на пункт
        OO = OO:sub(1,pos-2)..OO:sub(pos,pos)..OO:sub(pos-1,pos-1)..OO:sub(pos+1)
      elseif pos<OO:len() and(res.BreakKey=="C+DOWN" or res.BreakKey=="C+NUMPAD2") then -- опустить вниз на пункт
        OO = OO:sub(1,pos-1)..OO:sub(pos+1,pos+1)..OO:sub(pos,pos)..OO:sub(pos+2)
      end
    until false
--  elseif Form[Param1][1]==F.DI_BUTTON and Form[Param1-1][1]==F.DI_EDIT then -- ввод клавиши
  elseif Param1==30 then -- ввод клавиши-фильтра
    hDlg:send(F.DM_SETTEXT,Param1-1,(hDlg:send(F.DM_GETTEXT,Param1-1).." "..MacroKey(hDlg)):gsub("^ ","")) hDlg:send(F.DM_SETFOCUS,Param1-1)
  end
elseif Msg==F.DN_GOTFOCUS then
  if Param1==3 or Param1==5 or Param1==7 then ov = hDlg:send(F.DM_GETTEXT,Param1) end -- запомним старое значение
elseif Msg==F.DN_KILLFOCUS then
  if Param1==3 or Param1==5 or Param1==7 then -- di_edit?
    local nv = tonumber(hDlg:send(F.DM_GETTEXT,Param1)) -- новое значение
    if not nv then hDlg:send(F.DM_SETTEXT,Param1,ov) end -- плохое - откатим
  end
elseif Msg==F.DN_CONTROLINPUT and Param2.VirtualKeyCode then -- нажатие клавиши
  local ACS = band(Param2.ControlKeyState,0x1f) -- состояние Alt, Ctrl и Shift
  local tAlt = {[0x4d]=10,[0x4b]=11,[0x45]=13,[0x4f]=14,[0x49]=15,[0x50]=16,[0x4e]=17,[0x48]=12} -- элементы диалога для Alt+клавиша
  local tCtrl = {[0x4d]="Area",[0x45]="Group",[0x4f]="Path"} -- элементы диалога для Ctrl+клавиша
  local tShift = {[0x4d]="Macro",[0x45]="Event",[0x4f]="Module",[0x49]="MI",[0x50]="Prefix",[0x4e]="PM"} -- элементы диалога для Shift+клавиша
  if (Param2.VirtualKeyCode==0x70 and ACS==0) then -- F1
    ShowHelp("config")
  elseif Param2.VirtualKeyCode==0x4c and band(ACS,0xc)~=0 then -- CtrlL
    hDlg:send(F.DM_CLOSE,37) LoadSettings() Config() -- закроем диалог с отменой, загрузим сохранённые настройки, заново откроем диалог
  elseif Param2.VirtualKeyCode==0x0d and ACS==0x10 then -- ShiftEnter
    hDlg:send(F.DM_CLOSE,36) -- закроем диалог
  elseif Param2.VirtualKeyCode==0x4b and band(ACS,0xc)~=0 then -- CtrlK - фильтр клавиш макросов
    hDlg:send(F.DM_SETTEXT,29,((hDlg:send(F.DM_GETTEXT,29).." "..MacroKey(hDlg)):gsub("^ ",""))) hDlg:send(F.DM_SETFOCUS,29)
  elseif Param2.VirtualKeyCode==0x4b and band(ACS,3)~=0 and band(ACS,0xc)~=0 then -- CtrlAltK   - сбросить фильтр клавиш макросов
    hDlg:send(F.DM_SETTEXT,29,"") hDlg:send(F.DM_SETFOCUS,29) -- переключимся на поле фильтра клавиш
--  elseif Param2.VirtualKeyCode==0x46 and band(ACS,0xc)~=0 then -- CtrlF - фильтр файлов
  elseif ACS==0x10 and tShift[Param2.VirtualKeyCode] then -- Shift? - сортировка
    SO[tShift[Param2.VirtualKeyCode]] = SortingOrder(SO[tShift[Param2.VirtualKeyCode]],L["cb"..tShift[Param2.VirtualKeyCode].."SortVariants"])
  elseif band(ACS,0xc)~=0 and tCtrl[Param2.VirtualKeyCode] then -- Ctrl? - фильтр
    Filter[tCtrl[Param2.VirtualKeyCode]] = SetFilter(Filter[tCtrl[Param2.VirtualKeyCode]],L[tCtrl[Param2.VirtualKeyCode].."Items"])
  elseif band(ACS,3)~=0 and tAlt[Param2.VirtualKeyCode] then -- AltM - показать/скрыть регулярные макросы
    hDlg:send(F.DM_SETCHECK,tAlt[Param2.VirtualKeyCode],F.BSTATE_TOGGLE) -- симулируем нажатие
  else
    return false
  end
  hDlg:send(F.DM_REDRAW) return true
elseif Msg==F.DN_CLOSE then
  hDlg:send(F.DM_SETFOCUS,10) -- переключимся на чекбокс
end
end
--
if L[1] then return ErrMess(L[1]) end -- нет языковой информации - скажем и выйдем
Form = { -- диалог настройки конфигурации
--[[01]] {F.DI_DOUBLEBOX,   3, 1,74,14,0,0,0,0,L.diConf.Hdr},
--[[02]] {F.DI_TEXT,        5, 2, 0, 2,0,0,0,0,L.diConf.MaxKeyField},
--[[03]] {F.DI_EDIT,       34, 2,37, 2,0,0,0,0,S.MaxKeyWidth},
--[[04]] {F.DI_TEXT,       38, 2, 0, 2,0,0,0,0,L.diConf.MaxFileField},
--[[05]] {F.DI_EDIT,       48, 2,51, 2,0,0,0,0,S.MaxFileWidth},
--[[06]] {F.DI_TEXT,       52, 2, 0, 2,0,0,0,0,L.diConf.MaxDescField},
--[[07]] {F.DI_EDIT,       68, 2,72, 2,0,0,0,0,S.MaxDescWidth},
--[[08]] {F.DI_TEXT,       -1, 3, 0, 3,0,0,0,F.DIF_SEPARATOR,L.diConf.Show},
--[[09]] {F.DI_TEXT,        5, 4, 0, 4,0,0,0,0,L.diConf.Macro..":"},
--[[10]] {F.DI_CHECKBOX,   14, 4, 0, 4,S.Show.M and 1 or 0,0,0,0,L.diConf.ShowMacros},
--[[11]] {F.DI_CHECKBOX,   32, 4, 0, 4,S.Show.K and 1 or 0,0,0,0,L.diConf.ShowKeyMacros},
--[[12]] {F.DI_CHECKBOX,   50, 4, 0, 4,S.Show.H and 1 or 0,0,0,0,L.diConf.ShowNonActiveMacros},
--[[13]] {F.DI_CHECKBOX,    0, 5, 0, 5,S.Show.E and 1 or 0,0,0,0+F.DIF_CENTERGROUP,L.diConf.Event},
--[[14]] {F.DI_CHECKBOX,    0, 5, 0, 5,S.Show.O and 1 or 0,0,0,0+F.DIF_CENTERGROUP,L.diConf.Module},
--[[15]] {F.DI_CHECKBOX,    0, 5, 0, 5,S.Show.I and 1 or 0,0,0,0+F.DIF_CENTERGROUP,L.diConf.MenuItem},
--[[16]] {F.DI_CHECKBOX,    0, 5, 0, 5,S.Show.P and 1 or 0,0,0,0+F.DIF_CENTERGROUP,L.diConf.Prefixes},
--[[17]] {F.DI_CHECKBOX,    0, 5, 0, 5,S.Show.N and 1 or 0,0,0,0+F.DIF_CENTERGROUP,L.diConf.Panels},
--[[18]] {F.DI_TEXT,       -1, 6, 0, 6,0,0,0,F.DIF_SEPARATOR,L.diConf.SortingOrder},
--[[19]] {F.DI_BUTTON,      0, 7, 0, 7,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_CENTERGROUP,L.diConf.Macro},
--[[20]] {F.DI_BUTTON,      0, 7, 0, 7,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_CENTERGROUP,L.diConf.Event},
--[[21]] {F.DI_BUTTON,      0, 7, 0, 7,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_CENTERGROUP,L.diConf.Module},
--[[22]] {F.DI_BUTTON,      0, 7, 0, 7,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_CENTERGROUP,L.diConf.MenuItem},
--[[23]] {F.DI_BUTTON,      0, 8, 0, 8,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_CENTERGROUP,L.diConf.Prefixes},
--[[24]] {F.DI_BUTTON,      0, 8, 0, 8,0,0,0,F.DIF_BTNNOCLOSE+F.DIF_CENTERGROUP,L.diConf.Panels},
--[[25]] {F.DI_TEXT,        5, 9, 0, 9,0,0,0,0,L.diConf.ShowOrder},
--[[26]] {F.DI_BUTTON,     41, 9, 0, 9,0,0,0,F.DIF_BTNNOCLOSE,L.diConf.ChangeBtn},
--[[27]] {F.DI_TEXT,       -1,10, 0,10,0,0,0,F.DIF_SEPARATOR,L.diConf.Filter},
--[[28]] {F.DI_TEXT,        5,11, 0,11,0,0,0,0,L.diConf.KeyFilter},
--[[29]] {F.DI_EDIT,       12,11,29,11,0,0,0,0,S.Filter.K},
--[[30]] {F.DI_BUTTON,     30,11, 0,11,0,0,0,F.DIF_BTNNOCLOSE,L.diConf.ChangeBtn},
--[[31]] {F.DI_BUTTON,     42,11, 0,11,0,0,0,F.DIF_BTNNOCLOSE,L.diConf.AreaFilter},
--[[32]] {F.DI_BUTTON,     53,11, 0,11,0,0,0,F.DIF_BTNNOCLOSE,L.diConf.GroupFilter},
--[[33]] {F.DI_BUTTON,     63,11, 0,11,0,0,0,F.DIF_BTNNOCLOSE,L.diConf.PathFilter},
--[[34]] {F.DI_TEXT,       -1,12, 0,12,0,0,0,F.DIF_SEPARATOR,""},
--[[35]] {F.DI_BUTTON,      0,13, 0,13,0,0,0,F.DIF_DEFAULTBUTTON+F.DIF_CENTERGROUP,L.Save},
--[[36]] {F.DI_BUTTON,      0,13, 0,13,0,0,0,F.DIF_CENTERGROUP,L.NoSave},
--[[37]] {F.DI_BUTTON,      0,13, 0,13,0,0,0,F.DIF_CENTERGROUP,L.Cancel},
}
-- начало кода функции
Filter.Area,Filter.Group,Filter.Path,SO.Macro,SO.Event,SO.Module,SO.MI,SO.Prefix,SO.PM,OutOrder =
  S.Filter.A,S.Filter.G,S.Filter.P,S.SO.M,S.SO.E,S.SO.O,S.SO.I,S.SO.P,S.SO.N,S.Show.Order -- временные копии фильтров и порядка сортировки
local res = far.Dialog(Guids.Config,-1,-1,78,16,nil,Form,nil,DlgProc) -- вызовем диалог
if res~=35 and res~=36 then return end -- не "ОК" - уйдём
S.MaxKeyWidth,S.MaxFileWidth,S.MaxDescWidth = tonumber(Form[3][10]),tonumber(Form[5][10]),tonumber(Form[7][10])
S.Show.M,S.Show.K,S.Show.H,S.Show.E = Form[10][6]~=0,Form[11][6]~=0,Form[12][6]~=0,Form[13][6]~=0 -- новые значения
S.Show.O,S.Show.I,S.Show.P,S.Show.N,S.Show.Order = Form[14][6]~=0,Form[15][6]~=0,Form[16][6]~=0,Form[17][6]~=0,OutOrder
S.Filter.K,S.Filter.A,S.Filter.G,S.Filter.P = Form[29][10],Filter.Area,Filter.Group,Filter.Path
S.SO.M,S.SO.E,S.SO.O,S.SO.I,S.SO.P,S.SO.N = SO.Macro,SO.Event,SO.Module,SO.MI,SO.Prefix,SO.PM
if res==35 then SaveSettings() end -- сохраним в БД, если надо
end
--
if type(nfo)=="table" then nfo.config = Config end
--------------------------------------------------------------------------------
-- +
--[==[Вставка скрипта в редактируемый файл]==]
-- -
function InsertScriptIntoEditor(stype)
--
if not(stype==1 or stype==2 or stype==3 or stype==4 or stype==5) then stype = nil end -- если неверный тип скрипта, будем спрашивать
if L[1] then return ErrMess(L[1]) end -- нет языковой информации - скажем и выйдем
local text,err = CreateAsText(editor.GetFileName():match("%.%a*$"),nil,stype)
if text and text~="" then -- Получили текст? запишем новый скрипт в файл
  editor.UndoRedo(nil,F.EUR_BEGIN) -- начнём блок отмены
  local mode = band(editor.GetInfo().Options,F.EOPT_AUTOINDENT)~=0 -- запомним текущее состояние автоотступа
  editor.SetParam(nil,F.ESPT_AUTOINDENT,false) -- запретим автооступ
  editor.InsertText(nil,text.."\n") -- вставим скрипт
  editor.SetParam(nil,F.ESPT_AUTOINDENT,mode) -- восстановим старое значение автооступа
  editor.UndoRedo(nil,F.EUR_END) -- закончим блок отмены
elseif not text then ErrMess(err)
end
end
-- +
--[==[Редактирование скрипта под курсором]==]
-- -
function EditScriptUnderCursor(CL)
if L[1] then return ErrMess(L[1]) end -- нет языковой информации - скажем и выйдем
local list,curr,tmpname = {},{},far.MkTemp()..editor.GetFileName():match("%.%a*$") -- таблица для данных о скриптах, временный файл
local text = "" for i=1,Editor.Lines do text = text..Editor.GetStr(i).."\n" end -- достанем текст файла
if tmpname:match("%.(%a*)$"):upper()=="LUA" then -- lua?
  for _,s in ipairs({"Macro","Event","MenuItem","CommandLine"}) do -- выдернем все Macro, Event, MenuItem и CommandLine
    for t in text:gmatch(s.."%s*%b{}") do list[#list+1] = {text=t,type=s} end
  end
else -- moon
  local r = [[/^(([ \t]*)(Macro|Event|MenuItem|CommandLine|PanelModule)[ \t]*\n(\2[ \t]+[^\n]+\n)+)/m]]
  for s,_,t in regex.gmatch(text,r) do list[#list+1] = {text=s,type=t} end -- выдернем все Macro, Event, MenuItem и CommandLine
end
for i,v in ipairs(list) do -- найдём начало и конец каждого
  local _,n = text:sub(1,text:cfind(v.text,1,true)-1):gsub("\n","") -- переводов строк до
  list[i].l1,_,n = n+1,v.text:gsub("\n","") -- номер первой строки, переводов строк в
  list[i].l2 = list[i].l1+n -- номер последней строки
end
table.sort(list,function(a,b) return a.l1<b.l1 end) -- отсортируем по порядку расположения
if type(CL)~="number" then -- строка не указана?
  local items,res,pos = {}
  for _,t in ipairs(list) do
    items[#items+1] = {text=t.text:gsub("\n","\\n"),l=t.l1,t=t.text,type=t.type} -- добавим пункт меню
    if t.l1<=Editor.CurLine and t.l2>=Editor.CurLine then pos = #items end -- найдём тот, что содержит текущую строку
  end
  repeat
    res,pos = far.Menu({Title=L.SelScrTtl,Bottom="Enter,Esc,F3,CtrlEnter",SelectIndex=pos},items,{{BreakKey="F3"},{BreakKey="C+RETURN"}})
    if not res then return true,"Cancel"
    elseif res.BreakKey=="F3" then far.Message(items[pos].t,items[pos].type,";Ok","l")
    elseif res.BreakKey=="C+RETURN" then editor.SetPosition(nil,items[pos].l,1) return true,"SetPosition"
    else CL = res.l break end
  until false
end
for i = 1,#list do if list[i].l1<=CL and list[i].l2>=CL then curr=list[i] break end end -- найдём тот, что содержит текущую строку
if not curr.l1 then return false,L.er.NotFound end -- не нашли? уйдём
Write(tmpname,curr.text) -- закинем текст в файл
local tbl,lf = {},tmpname:match("%.(%a*)$"):upper()=="LUA" and loadfile or require"moonscript".loadfile -- функция загрузки текста
local Proc,res,err = function(arg) tbl=arg end,lf(tmpname) -- функция для доставания, загруженный кусок или ошибка
if res then res,err = pcall(setfenv(res,{Macro=Proc,Event=Proc,MenuItem=Proc,CommandLine=Proc,PanelModule=Proc})) end -- загрузим и выполним файл
if not res then ErrMess(err,L.er["E"..curr.type]) return false,err end -- ошибка - скажем и выйдем
if tbl.guid then -- MenuItem?
  tbl.flags,tbl.guid = {},win.Uuid(tbl.guid) -- добавим флаги, приведём guid в нужный формат.
  for m in tbl.menu:lower():gmatch("%S+") do if m=="plugins" or m=="disks" or m=="config" then tbl.flags[m]=true end end -- добавим флаги меню
end
tbl.FileName,tbl.flags = tmpname,tbl.flags or 0 -- дополним необходимыми полями
tbl.descr = (tbl.description and not (tbl.code and tbl.description=="")) and "'"..tbl.description.."'" or "index= ?"
({Macro=OpenMacroInDialog,Event=OpenEventInDialog,MenuItem=OpenMenuItemInDialog,CommandLine=OpenPrefixInDialog})[curr.type](tbl,false,true) -- сделаем
local newtxt = Read(tmpname) if newtxt==curr.text then return true end -- достанем новый текст. не изменился? ничего не делаем
local b,e = text:cfind(curr.text,1,true) text = text:sub(1,b-1)..newtxt..text:sub(e+1) -- заменим правленый фрагмент
editor.UndoRedo(nil,F.EUR_BEGIN) -- начнём блок отмены
for i=curr.l1,curr.l2 do Editor.SetStr(text:gsub(".-\n","",i-1):match("^[^\n]*"),i) end -- заменим текст скрипта
for i=curr.l2,newtxt:gsub("[^\n]*",""):len()+curr.l1-1 do Editor.InsStr(text:gsub(".-\n","",i-1):match("^[^\n]*"),i) end
editor.UndoRedo(nil,F.EUR_END) -- закончим блок отмены
return true
end
-- +
--[==[Перезагрузка скриптов из редактора]==]
-- -
function Reload(onnotsaved)
if Area.Editor and band(editor.GetInfo().CurState,F.ECSTATE_SAVED)==0 then -- в редакторе и файл не сохранён?
  local ans = onnotsaved and ({save=1,ignore=2,cancel=3})[onnotsaved] or (not L[1] and far.Message(L.NotSaved,"",L.NotSavedBtns) or 1) -- что делать?
  if ans==1 then editor.SaveFile() elseif ans~=2 then return end -- сохранить и перезагрузить? сохраним; ничего не делать? выйдем
end
if far.MacroLoadAll() then far.Message(L[1] and "OK" or L.ReloadDone,"","") far.Text() mf.waitkey(2000) end -- обновим макросы в Farе
end
-- +
--[==[main function]==]
-- -
local oldpos -- сохранённая позиция курсора
function ManageMacrosEvents(PTable)
-- На входе таблица с полями:
--  MaSort,EvSort,MoSort,MISort,PrSort - сортировка макросов, обработчиков событий, модулей, пунктов меню плагинов и префиксов командной строки;
--   параметр - строка букв, можно посмотреть в языковых файлах в cbXXXSortVariants; заглавная/строчная буква - сортировка по возрастанию/убыванию.
--  AFilter,KFilter,GFilter,PFilter,FFilter,SFilter - фильтр областей, клавиш, групп, путей поиска модулей, файлов со скриптами, пакетов скриптов.
--  MaShow,KMShow,EvShow,MoShow,MIShow,PrShow,PMShow,AMShow - показывать стационарные/клавиатурные макросы/обработчики событий/модули/пункты меню
--   плагинов/префиксы командной строки/панельные модули, макросы из неактивных областей.
-- Значения пропущенных полей берутся из конфигурации скрипта.
--
local function ShortArea(area) -- сворачивает список областей в короткую строку фиксированной длины
local tbl = {{s="S",l=" SHELL "},{s="I",l=" INFO "},{s="Q",l=" QVIEW "},{s="T",l=" TREE "},{s="s",l=" SEARCH "},
  {s="F",l=" FINDFOLDER "},{s="V",l=" VIEWER "},{s="E",l=" EDITOR "},{s="D",l=" DIALOG "},{s="m",l=" MENU "},{s="M",l=" MAINMENU "},
  {s="U",l=" USERMENU "},{s="d",l=" DISKS "},{s="A",l=" SHELLAUTOCOMPLETION "},{s="a",l=" DIALOGAUTOCOMPLETION "},{s="H",l=" HELP "},
  {s="G",l=" GRABBER "},{s="e",l=" DESKTOP "},{s="O",l=" OTHER "},{s="C",l=" COMMON "}}
local a,au = ""," "..area:upper().." "
for _,sl in ipairs(tbl) do a = a..(au:find(sl.l) and sl.s or "·") end
return a
end
--
local function ShortGroup(group) -- сворачивает список областей в короткую строку фиксированной длины
local tbl = {{s=" DE",l="DIALOGEVENT"},{s=" VE",l="VIEWEREVENT"},{s=" EE",l="EDITOREVENT"},{s=" EI",l="EDITORINPUT"},{s=" CI",l="CONSOLEINPUT"},
  {s=" EF",l="EXITFAR"}}
local g,gu = ""," "..group:upper().." "
for _,sl in ipairs(tbl) do g = g..(gu:find(sl.l) and sl.s or " · ") end
return g
end
--
local function CompareMacros(a,b) -- сравнение 2 макросов по: "COMMON"?, текущая?, по областям, по клавишам, по маскам файлов, по описаниям
local a1,b1,cUp
for c in S.SO.M:gmatch(".") do cUp = c:upper()
  if cUp=="O" then a1,b1 = a.area:upper():cfind("COMMON") and 1 or 2,b.area:upper():cfind("COMMON") and 1 or 2
  elseif cUp=="C" then a1,b1 = a.area:upper():cfind(Area.Current:upper()) and 1 or 2,b.area:upper():cfind(Area.Current:upper()) and 1 or 2
  elseif cUp=="A" then a1,b1 = ShortArea(a.area),ShortArea(b.area)
  elseif cUp=="K" then a1,b1 = a.key:upper() or "",b.key:upper() or ""
  elseif cUp=="F" then a1,b1 = a.filemask or "",b.filemask or ""
  elseif cUp=="D" then a1,b1 = a.description or "",b.description or "" end
  if far.LIsLower(c) then a1,b1 = b1,a1 end if a1~=b1 then return a1<b1 end
end
end
--
local function CompareEvents(a,b) -- сравнение 2 обработчиков событий по: 1 - по группам; 2 - по маскам файлов; 3 - по описаниям
local a1,b1,cUp
for c in S.SO.E:gmatch(".") do cUp = c:upper()
  if cUp=="G" then a1,b1 = ShortGroup(a.group),ShortGroup(b.group)
  elseif cUp=="F" then a1,b1 = a.filemask or "",b.filemask or ""
  elseif cUp=="D" then a1,b1 = a.description or "",b.description or "" end
  if far.LIsLower(c) then a1,b1 = b1,a1 end if a1~=b1 then return a1<b1 end
end
end
--
local function CompareModules(a,b) -- сравнение 2 модулей по: 1 - тип; 2 - маска поиска; 3 - имя
local a1,b1,cUp
for c in S.SO.O:gmatch(".") do cUp = c:upper()
  if cUp=="T" then a1,b1 = a.type,b.type
  elseif cUp=="M" then a1,b1 = a.mask,b.mask
  elseif cUp=="N" then a1,b1 = a.name,b.name end
  if far.LIsLower(c) then a1,b1 = b1,a1 end if a1~=b1 then return a1<b1 end
end
end
--
local function CompareMenuItems(a,b) -- сравнение 2 пунктов меню плагинов по: использующие меню, область, "COMMON"?, текущая?, описание
local AN,PDC,a1,b1,cUp,num = {1,10,11,12,5,13,2,3,4,8,7,14,6,15,16,9,17,18,0,"common"},{"plugins","disks","config"}
for c in S.SO.I:gmatch(".") do cUp = c:upper()
  if cUp=="M" then a1,b1 = "","" for _,m in pairs(PDC) do a1,b1 = a1..(a.flags[m]and"1"or"2"),b1..(b.flags[m]and"1"or"2") end
  elseif cUp=="O" then a1,b1 = a.flags.common and 1 or 2,b.flags.common and 1 or 2
  elseif cUp=="C" then num = AreasRev[Area.Current:lower()] a1,b1 = a.flags[num] and 1 or 2,b.flags[num] and 1 or 2
  elseif cUp=="A" then a1,b1 = "","" for _,n in pairs(AN) do a1,b1 = a1..(a.flags[n]and"1"or"2"),b1..(b.flags[n]and"1"or"2") end
  elseif cUp=="D" then a1,b1 = a.description or "",b.description or "" end
  if far.LIsLower(c) then a1,b1 = b1,a1 end if a1~=b1 then return a1<b1 end
end
end
--
local function ComparePrefixes(a,b) -- сравнение 2 префиксов командной строки по: префикс, описание
local a1,b1,cUp
for c in S.SO.P:gmatch(".") do cUp = c:upper()
  if cUp=="P" then a1,b1 = a.prefix,b.prefix
  elseif cUp=="D" then a1,b1 = a.description or "",b.description or "" end
  if far.LIsLower(c) then a1,b1 = b1,a1 end if a1~=b1 then return a1<b1 end
end
end
--
local function ComparePanels(a,b) -- сравнение 2 панельных модулей по: описание, заголовок, автор
local a1,b1,cUp
for c in S.SO.N:gmatch(".") do cUp = c:upper()
  if cUp=="D" then a1,b1 = a.Info.Description or "",b.Info.Description or ""
  elseif cUp=="T" then a1,b1 = a.Info.Title or "",b.Info.Title or ""
  elseif cUp=="A" then a1,b1 = a.Info.Author or "",b.Info.Author or "" end
  if far.LIsLower(c) then a1,b1 = b1,a1 end if a1~=b1 then return a1<b1 end
end
end
--
local function ProcMod(_,fullname,bp,fmask,mask,modules,off) -- обработка найденных потенциальных модулей
local mn,fn = fullname:sub(bp:len()+1):gsub(OffExt.."$",""):gsub("%.%a*$",""):gsub("\\","."),fullname -- имя модуля
if mask:find("?\\init",1,true) then -- модуль - каталог с init.lua внутри?
  mn,fn = mn:match("^(.*)%.init$"),fullname:gsub(OffExt.."$",""):match("^(.*)init%.%a*$") -- скорректируем имя модуля и полный путь
else -- модуль - .lua-файл
  if mn:find("%.init$") then return end -- init.lua? пропускаем
end
if FMatch(fullname,fmask..";"..fmask..OffExt)>0 and not modules[fn] then -- подходит по маске файла и ещё не найден? добавим в таблицу
  if off then -- перебираем отключённые?
    modules[fn] = {res="?",disabled=true,name=mn,realbase=bp,realname=fullname,mask=mask,FileName=fn,type=mask:match("%.(%a*)$"):lower()} -- добавим
  else
    modules[fn] = {res=package.loaded[mn],name=mn,realbase=bp,realname=fullname,mask=mask,FileName=fn,type=mask:match("%.(%a*)$"):lower()} -- добавим
  end
end
end
-- старт
if L[1] then return ErrMess(L[1]) else LoadSettings() end -- нет языковой информации - скажем и выйдем, иначе загрузим настройки
if type(PTable)~="table" then PTable = {} end
if PTable.ResetFilters then -- сбросить все фильтры? сбросим
  S.Filter,S.Show = {A=Def.AreaFilter,K="",G=Def.GroupFilter,P=Def.PathFilter,F="*"},{M=true,K=true,E=true,O=true,I=true,P=true,N=true,H=true}
end
S.SO.M,S.SO.E,S.SO.O,S.SO.I = PTable.MaSort or S.SO.M,PTable.EvSort or S.SO.E,PTable.MoSort or S.SO.O,PTable.MISort or S.SO.I
S.SO.P = PTable.PrSort or S.SO.P
S.Filter.A,S.Filter.K,S.Filter.G = PTable.AFilter or S.Filter.A,PTable.KFilter or S.Filter.K,PTable.GFilter or S.Filter.G
S.Filter.P,S.Filter.F = PTable.PFilter or S.Filter.P,(not PTable.FFilter or FMatch(">:<",PTable.FFilter)<0) and "*" or PTable.FFilter
if PTable.SFilter and type(PTable.SFilter)=="string" then
  if not rs then
    ErrMess(L.er.No_regscript)
  else
    local info
    for _,i in ipairs(rs.scripts) do if i.name==PTable.SFilter then info = i break end end -- заполним список
    if info then
      local files = {info.FileName} -- список файлов, входящих в пакет
      for _,i in ipairs(rs.scripts) do if i.parent_id==info.id then files[#files+1] = i.FileName end end -- заполним список
      S.Filter.F = table.concat(files,",")..L.PkgFilter..info.description -- изменим маску файла
    else
      ErrMess(L.er.NoScript)
    end
  end
end
if PTable.MaShow~=nil then S.Show.M = PTable.MaShow end if PTable.KMShow~=nil then S.Show.K = PTable.KMShow end -- скорректируем настройки
if PTable.EvShow~=nil then S.Show.E = PTable.EvShow end if PTable.MoShow~=nil then S.Show.O = PTable.MoShow end --  в соответствии
if PTable.MIShow~=nil then S.Show.I = PTable.MIShow end if PTable.PrShow~=nil then S.Show.P = PTable.PrShow end --  с параметрами функции
if PTable.PMShow~=nil then S.Show.N = PTable.PMShow end if PTable.AMShow~=nil then S.Show.H = PTable.AMShow end
repeat -- работаем, пока не надоест
  local ff = S.Filter.F:match("^[^\n]*")
  local events,macros,keymacros,modules,menuitems,prefixes,panels,items = {},{},{},{},{},{},{},{}
  local KeyW,MDescW,GroupW,MaskW,FileW,EDescW,MNameW,MMaskW,MIDescW,PrPrefW,PrDescW,PMTtlW,PMDescW = 0,0,0,0,0,0,0,0,0,0,0,0,0
  for k=1,math.huge do -- переберём все мыслимые idы
    local me = mf.GetMacroCopy(k) -- получим макрос/обработчик событий
    if not me then break end -- кончились - закончим перебор
    if not _G.utf8.utf8valid(me.description or "") then me.description = win.Utf16ToUtf8(win.MultiByteToWideChar(me.description,win.GetACP())) end
    me.descr = (me.description and not (me.code and me.description=="")) and "'"..me.description.."'" or "index="..me.index
    me.desc2 = (me.description and not (me.code and me.description=="")) and me.description or "index="..me.index
    local infilter = me.needsave or FMatch(me.FileName or "",ff)>0 -- отсеем по файловой маске
    if me.area then -- это макрос?
      me.key = me.key or NoKey -- если вдруг нету клавиш
      infilter = infilter and regex.find(" "..S.Filter.A.." ","/( "..me.area:gsub(" "," | ").." )/i") -- отфильтруем по областям
      if me.code then infilter = infilter and S.Show.K else infilter = infilter and S.Show.M end -- отсеем отключённые
      if S.Filter.K:lower()=="none" then -- выводим только с псевдоклавишами?
        infilter = infilter and not me.key:match("^/.*/$") -- регэкспы отсеиваем
        for sk in me.key:gmatch("%S+") do infilter = infilter and not far.NameToInputRecord(sk:gsub("LCtrl","Ctrl"):gsub("LAlt","Alt")) end
      else -- с нормальными
        infilter = infilter and (S.Filter.K=="" or (me.key:match("^/.*/$") and regex.find(S.Filter.K,me.key,1,"i"))
          or regex.find(me.key,"/(^| )"..S.Filter.K.."($| )/i")) -- отсеем клавиши
      end
      infilter = infilter and (S.Show.H or regex.find(" "..me.area.." ","/( Common | "..Area.Current.." )/i")) -- отсеем нетекущие?
      if infilter then -- не отфильтрован?
        if me.code then keymacros[#keymacros+1] = me else macros[#macros+1] = me end -- запомним
        KeyW = math.max(KeyW,me.key:len()) -- вычислим максимальную ширину поля клавиши, имени файла и описания
        FileW = math.max(FileW,(me.FileName or ""):match("[^\\]*$"):len())
        for s in (me.desc2.."\n"):gmatch("([^\n]*)\n") do MDescW = math.max(MDescW,s:len()) end
      end
    else -- это обработчик событий
      infilter = infilter and (" "..S.Filter.G:upper().." "):find(" "..me.group:upper().." ") -- отфильтруем по группе
      if infilter and S.Show.E then -- не отфильтрован и не отключены?
        events[#events+1],GroupW,MaskW =  -- запомним обработчик событий, вычислим максимальную ширину поля группы, имени файла,
          me,math.max(GroupW,me.group:len()),math.max(MaskW,me.filemask and me.filemask:len() or 0) --  маски файлов и описания
        FileW = math.max(FileW,(me.FileName or ""):match("[^\\]*$"):len())
        for s in (me.desc2.."\n"):gmatch("([^\n]*)\n") do EDescW = math.max(EDescW,s:len()) end
      end
    end
  end -- for - перебор id
  if S.Show.O then -- показывать модули?
    for v in S.Filter.P:gmatch('"([^"]*)"') do -- переберём все возможные места расположения модулей
      local path,fmask = far.ConvertPath(v):gsub("%?","*"):match("^([^%*]*).-([^\\]*)$") -- путь и маска
      far.RecursiveSearch(path,fmask,ProcMod,F.FRS_RECUR,path,ff,v,modules) -- переберём все кандидаты
      far.RecursiveSearch(path,fmask..OffExt,ProcMod,F.FRS_RECUR,path,ff,v,modules,OffExt) -- переберём все кандидаты
    end
  end
  if MenuItems and S.Show.I then -- показывать пункты меню?
    for _,t in ipairs(MenuItems) do -- переберём все
      local tbl,infilter = {},false -- копия элемента, признак прохождения фильтра
      for n,v in pairs(t) do tbl[n] = v end -- заполним
      if not _G.utf8.utf8valid(tbl.description or "") then tbl.description = win.Utf16ToUtf8(win.MultiByteToWideChar(tbl.description,win.GetACP())) end
      tbl.desc2 = t.description~="" and t.description or "index="..t.index
      tbl.descr = t.description~="" and "'"..t.description.."'" or "index="..t.index
      for a in S.Filter.A:gmatch("%w+") do infilter = infilter or t.flags[AreasRev[a:lower()]] end -- отфильтруем по областям
      if FMatch(t.FileName or"",ff)>0 and infilter and(S.Show.H or t.flags.common or t.flags[AreasRev[Area.Current:lower()]]) then -- отсеем по прочему
        menuitems[#menuitems+1] = tbl -- добавим, посчитаем максимальную длину описания
        FileW = math.max(FileW,(tbl.FileName or ""):match("[^\\]*$"):len())
        for s in (tbl.desc2.."\n"):gmatch("([^\n]*)\n") do MIDescW = math.max(MIDescW,s:len()) end
      end
    end
  end
  if Prefixes and S.Show.P then -- показывать префиксы?
    for p in Prefixes[1]:gmatch("[^:]+") do -- переберём все
      local tbl = {} -- копия элемента
      for n,v in pairs(Prefixes[p]) do tbl[n] = v end -- заполним и
      if not _G.utf8.utf8valid(tbl.description or "") then tbl.description = win.Utf16ToUtf8(win.MultiByteToWideChar(tbl.description,win.GetACP())) end
      if FMatch(tbl.FileName or"",ff)>0 then -- отсеем по файловой маске
        prefixes[#prefixes+1],PrPrefW = tbl,math.max(PrPrefW,p:len()) -- добавим
        FileW = math.max(FileW,(tbl.FileName or ""):match("[^\\]*$"):len())
        for s in (tbl.description.."\n"):gmatch("([^\n]*)\n") do PrDescW = math.max(PrDescW,s:len()) end
      end
    end
  end
  if PanelModules and (S.Show.N) then -- показывать панельные модули?
    for _,t in ipairs(PanelModules) do -- переберём все
      local tbl = {Info={}} -- копия элемента
      for n,v in pairs(t.Info) do tbl.Info[n] = v end -- заполним
      for n,v in pairs(t) do if n~="Info" then tbl[n] = v end end -- заполним
      if not _G.utf8.utf8valid(tbl.Info.Description or "") then
        tbl.Info.Description = win.Utf16ToUtf8(win.MultiByteToWideChar(tbl.Info.Description,win.GetACP())) end
      tbl.descr = (t.Info.Title and "'"..t.Info.Title.."'") or (t.Info.Description and "'"..t.Info.Description.."'") or Noid
      if FMatch(t.FileName or"",ff)>0 then -- отсеем по файловой маске
        panels[#panels+1] = tbl -- добавим, посчитаем максимальную длину описания
        FileW = math.max(FileW,(tbl.FileName or ""):match("[^\\]*$"):len())
        PMTtlW = math.max(PMTtlW,(t.Info.Title or ""):len())
        for s in ((tbl.Info.Description or "").."\n"):gmatch("([^\n]*)\n") do PMDescW = math.max(PMDescW,s:len()) end
      end
    end
  end
  local tmp = {} -- временная таблица для перехода со строковых индексов на числовые (для сортировки и т. п.)
  for n,m in pairs(modules) do -- вычислим, сколько места надо под имена и маски поиска
    MNameW,MMaskW,tmp[#tmp+1] = math.max(MNameW,m.name:len()),math.max(MMaskW,m.mask:len()),modules[n] -- имена и маски поиска модулей, записи
    FileW = math.max(FileW,(m.FileName or ""):match("[^\\]*$"):len())
  end
  modules = tmp -- теперь таблица индексирована числами
  table.sort(macros,CompareMacros) table.sort(keymacros,CompareMacros) table.sort(events,CompareEvents) table.sort(modules,CompareModules)
  table.sort(menuitems,CompareMenuItems) table.sort(prefixes,ComparePrefixes) table.sort(panels,ComparePanels) -- отсортируем всё
  local hf,af,gf,pf,prf,pnf,pos = S.Show.H and""or"(-H)",ShortArea(S.Filter.A)==ShortArea(Def.AreaFilter)and""or"(A="..ShortArea(S.Filter.A)..")",
    S.Filter.G==Def.GroupFilter and""or "(G="..ShortGroup(S.Filter.G)..")",S.Filter.P==Def.PathFilter and""or"*","","",1 -- фильтры в подзаголовки
  if S.MaxKeyWidth~=0 then KeyW = math.min(KeyW,math.abs(S.MaxKeyWidth)) end -- место под клавиши с учётом ограничения
  FileW = S.MaxFileWidth~=0 and math.min(FileW,math.abs(S.MaxFileWidth)) or 0 -- место под имя файла с учётом разделителя
  local W4,W3,W2--[[,W1--]] = 4*2+3*3,4*2+3*2,4*2+3--[[,4*2--]] -- место занимаемое элементами формата для разного количества колонок
  if S.MaxDescWidth~=0 and S.MaxDescWidth~=-1 then -- место под описания, место под маски: с учётом ограничения
    MDescW  = math.min(MDescW ,math.abs(S.MaxDescWidth),Far.Width-AreasCount-KeyW-FileW-(FileW>0 and W4 or W3))
    EDescW  = math.min(EDescW ,math.abs(S.MaxDescWidth),Far.Width-GroupW-MaskW-FileW-(FileW+MaskW==0 and W2 or (FileW*MaskW==0 and W3 or W4)))
    MMaskW  = math.min(MMaskW ,math.abs(S.MaxDescWidth),Far.Width-MNameW-FileW-(FileW>0 and W3 or W2))
    MIDescW = math.min(MIDescW,math.abs(S.MaxDescWidth),Far.Width-AreasCount-3-FileW-(FileW>0 and W4 or W3))
    PrDescW = math.min(PrDescW,math.abs(S.MaxDescWidth),Far.Width-PrPrefW-FileW-(FileW>0 and W3 or W2))
    PMDescW = math.min(PMDescW,math.abs(S.MaxDescWidth),Far.Width-AreasCount-FileW-(FileW>0 and W4 or W3))
  end
  for c in S.Show.Order:gmatch(".") do -- посортируем все элементы в порядке вывода типов
    if c=="M" and #macros>0 then -- макросы, если есть
      items[#items+1] = {separator=true,text=L.Mac..hf..af..(S.Filter.K==""and""or"(K="..S.Filter.K..")")} -- подзаголовок
      local frm = "%s │%1s%-"..(KeyW+1)..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..MDescW.."s" -- формат для строки элемента
      for _,m in ipairs(macros) do -- переберём все
        local K,FN,D,f = {},{},{},(m.FileName or L.Absent):match("[^\\]*$") -- разобьём клавиши, имена файлов и описания на подстроки
        for i=1,m.key:len(),KeyW do K[#K+1] = m.key:sub(i,i+KeyW-1) end
        if S.MaxKeyWidth<0 and K[2] then K = {K[1]..CNT} end -- если клавиши в одну строку, урезаются и эти урезаны, исправим
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for s in (m.desc2.."\n"):gmatch("([^\n]*)\n") do -- выводим описание построчно
          if S.MaxDescWidth==-1 then D[#D+1] = s..(m.desc2:find("\n") and CNT or "") break end -- первую
          for i=1,s:len(),MDescW do if S.MaxDescWidth<0 and i>1 then D[#D] = D[#D]:sub(1,-2)..CNT break end D[#D+1] = s:sub(i,i+MDescW-1) end
        end
        m.desc2 = nil -- расширенное описание больше не нужно
        local gr,ch,re = not regex.find(" "..m.area.." ","/( Common | "..Area.Current.." )/i"),m.disabled and DSB,m.rebinded and RBN or " "
        items[#items+1] = {from=m,grayed=gr,checked=ch,pos="M"..m.index,text=frm:format(ShortArea(m.area),re,K[1],FN[1] or "",D[1] or "")}
        if oldpos==items[#items].pos then pos = #items end
        for j=2,math.max(#K,#FN,#D) do
          items[#items+1] = {from=m,grayed=gr,checked=ch,pos="M"..m.index,text=frm:format((" "):rep(AreasCount),"",K[j]or"",FN[j] or "",D[j] or "")}
        end
      end
    end
    if c=="K" and #keymacros>0 then -- клавиатурные макросы, если есть
      items[#items+1] = {separator=true,text=L.Key..hf..af..(S.Filter.K==""and""or"(K="..S.Filter.K..")")} -- подзаголовок
      local frm = "%s │%1s%-"..(KeyW+1)..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..MDescW.."s" -- формат для строки элемента
      for _,m in ipairs(keymacros) do -- переберём все
        local K,FN,D,f = {},{},{},(m.FileName or L.Absent):match("[^\\]*$") -- разобьём клавиши, имена файлов и описания на подстроки
        for i=1,m.key:len(),KeyW do K[#K+1] = m.key:sub(i,i+KeyW-1) end
        if S.MaxKeyWidth<0 and K[2] then K = {K[1]..CNT} end -- если клавиши в одну строку, урезаются и эти урезаны, исправим
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for s in (m.desc2.."\n"):gmatch("([^\n]*)\n") do -- выводим описание построчно
          if S.MaxDescWidth==-1 then D[#D+1] = s..(m.desc2:find("\n") and CNT or "") break end -- первую
          for i=1,s:len(),MDescW do if S.MaxDescWidth<0 and i>1 then D[#D] = D[#D]:sub(1,-2)..CNT break end D[#D+1] = s:sub(i,i+MDescW-1) end
        end
        m.desc2 = nil -- расширенное описание больше не нужно
        local gr,ch,re = not regex.find(" "..m.area.." ","/( Common | "..Area.Current.." )/i"),m.disabled and DSB,m.rebinded and RBN or ""
        items[#items+1] = {from=m,grayed=gr,checked=ch,pos="M"..m.index,text=frm:format(ShortArea(m.area),re,K[1],FN[1] or "",D[1] or "")}
        if oldpos==items[#items].pos then pos = #items end
        for j=2,math.max(#K,#FN,#D) do
          items[#items+1] = {from=m,grayed=gr,checked=ch,pos="M"..m.index,text=frm:format((" "):rep(AreasCount),"",K[j]or"",FN[j] or "",D[j] or "")}
        end
      end
    end
    if c=="E" and #events>0 then -- обработчики событий, если есть
      items[#items+1] = {separator=true,text=L.Events..gf} -- подзаголовок
      local frm = "%-"..(GroupW+1)..(MaskW>0 and "s│ %-"..(MaskW+1) or "s%")..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..EDescW.."s"
      for _,e in ipairs(events) do -- переберём все
        if rb then e.condition,e.original_condition = e.original_condition,nil end
        local FN,D,f = {},{},(e.FileName or L.Absent):match("[^\\]*$") -- разобьём имена файлов и описания на подстроки
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for s in (e.desc2.."\n"):gmatch("([^\n]*)\n") do -- выводим описание построчно
          if S.MaxDescWidth==-1 then D[#D+1] = s..(e.desc2:find("\n") and CNT or "") break end -- первую
          for i=1,s:len(),EDescW do if S.MaxDescWidth<0 and i>1 then D[#D] = D[#D]:sub(1,-2)..CNT break end D[#D+1] = s:sub(i,i+EDescW-1) end
        end
        e.desc2 = nil -- расширенное описание больше не нужно
        items[#items+1] = {from=e,grayed=true,checked=e.disabled and DSB,pos="E"..e.index,text=frm:format(e.group,e.filemask or"",FN[1] or"",D[1] or"")}
        if oldpos==items[#items].pos then pos = #items end
        for j=2,math.max(#FN,#D) do
          items[#items+1] = {from=e,grayed=true,checked=e.disabled and DSB,pos="E"..e.index,text=frm:format("","",FN[j] or"",D[j] or"")}
        end
      end
    end
    if c=="O" and #modules>0 then -- модули, если есть
      items[#items+1] = {separator=true,text=L.Modules..pf} -- подзаголовок
      local frm = "%-"..(MNameW+1)..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..MMaskW.."s"
      for _,m in ipairs(modules) do -- переберём все
        local FN,M,f = {},{},(m.FileName or L.Absent):gsub("\\$","\\init.lua"):match("[^\\]*$") -- разобьём имена файлов и маски поиска модуля
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for i=1,m.mask:len(),MMaskW do if S.MaxDescWidth<0 and i>1 then M[#M] = M[#M]:sub(1,-2)..CNT break end M[#M+1] = m.mask:sub(i,i+MMaskW-1) end
        if (S.MaxDescWidth==0)or(S.MaxDescWidth==-1) then M = {m.mask} end -- если маска не разбивается
        items[#items+1] = {from=m,grayed=true,checked=m.disabled and DSB,pos="O"..m.name,text=frm:format(m.name,FN[1] or "",M[1])}
        if oldpos==items[#items].pos then pos = #items end
        for j=2,math.max(#FN,#M) do
          items[#items+1] = {from=m,grayed=true,checked=m.disabled and DSB,pos="O"..m.name,text=frm:format("",FN[j] or "",M[j] or "")}
        end
      end
    end
    if c=="I" and #menuitems>0 then -- пункты меню плагинов, если есть
      items[#items+1] = {separator=true,text=L.MenuItems..hf..af} -- подзаголовок
      local frm = "%s │ %-4"..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..MIDescW.."s"
      for _,mi in ipairs(menuitems) do -- переберём все
        local smenu,area = (mi.flags.plugins and"P"or".")..(mi.flags.config and"C"or".")..(mi.flags.disks and"D"or"."),"" -- меню, области действия
        for n,v in pairs(Areas) do area = area.." "..(mi.flags[n] and v or "") end
        local FN,D,f = {},{},(mi.FileName or L.Absent):match("[^\\]*$") -- разобьём имена файлов и описания на подстроки
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for s in (mi.desc2.."\n"):gmatch("([^\n]*)\n") do -- выводим описание построчно
          if S.MaxDescWidth==-1 then D[#D+1] = s..(mi.desc2:find("\n") and CNT or "") break end -- первую
          for i=1,s:len(),MIDescW do if S.MaxDescWidth<0 and i>1 then D[#D] = D[#D]:sub(1,-2)..CNT break end D[#D+1] = s:sub(i,i+MIDescW-1) end
        end
        mi.desc2 = nil -- расширенное описание больше не нужно
        local gr = not(mi.flags.common or area:lower():find(Area.Current:lower())) -- повторяемые элементы
        items[#items+1] = {from=mi,grayed=gr,pos="I"..mi.guid,text=frm:format(ShortArea(area),smenu,FN[1] or "",D[1] or "")}
        if oldpos==items[#items].pos then pos = #items end
        for j = 2,math.max(#FN,#D) do
          items[#items+1] = {from=mi,grayed=gr,pos="I"..mi.guid,text=frm:format((" "):rep(AreasCount),"",FN[j] or "",D[j] or "")}
        end
      end
    end
    if c=="P" and #prefixes>0 then -- префиксы, если есть
      items[#items+1] = {separator=true,text=L.Prefixes..prf} -- подзаголовок
      local frm = "%-"..(PrPrefW+1)..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..PrDescW.."s"
      for _,p in ipairs(prefixes) do -- переберём все
        local FN,D,f = {},{},(p.FileName or L.Absent):match("[^\\]*$") -- разобьём имена файлов и описания на подстроки
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for s in (p.description.."\n"):gmatch("([^\n]*)\n") do -- выводим описание построчно
          if S.MaxDescWidth==-1 then D[#D+1] = s..(p.description:find("\n") and CNT or "") break end -- первую
          for i=1,s:len(),PrDescW do if S.MaxDescWidth<0 and i>1 then D[#D] = D[#D]:sub(1,-2)..CNT break end D[#D+1] = s:sub(i,i+PrDescW-1) end
        end
        items[#items+1] = {from=p,grayed=not Area.Shell,pos="P"..p.prefix,text=frm:format(p.prefix,FN[1] or "",D[1] or "")}
        if oldpos==items[#items].pos then pos = #items end
        for j = 2,math.max(#FN,#D) do items[#items+1] = {from=p,grayed=not Area.Shell,pos="P"..p.prefix,text=frm:format("",FN[j] or "",D[j] or "")} end
      end
    end
    if c=="N" and #panels>0 then -- панельные модули, если есть
      items[#items+1] = {separator=true,text=L.Panels..pnf} -- подзаголовок
      local frm = "%"..#FuncNames.."s │ %-"..(PMTtlW+1)..(S.MaxFileWidth~=0 and "s│ %-"..(FileW+1) or "s%").."s│ %-"..PMDescW.."s"
      for _,p in ipairs(panels) do -- переберём все
        local FN,D,f,fnl = {},{},(p.FileName or L.Absent):match("[^\\]*$"),"" -- разобьём имена файлов и описания на подстроки
        if S.MaxFileWidth~=0 then for i=1,f:len(),FileW do FN[#FN+1] = f:sub(i,i+FileW-1) end end -- разобьём имя файла на части
        if S.MaxFileWidth<0 and FN[2] then FN = {FN[1]..CNT} end -- если имя файла в одну строку, урезается и не влазит в одну строку, исправим
        for s in ((p.Info.Description or "").."\n"):gmatch("([^\n]*)\n") do -- выводим описание построчно
          if S.MaxDescWidth==-1 then D[#D+1] = s..((p.Info.Description or ""):find("\n") and CNT or "") break end -- первую
          for i=1,s:len(),PMDescW do if S.MaxDescWidth<0 and i>1 then D[#D] = D[#D]:sub(1,-2)..CNT break end D[#D+1] = s:sub(i,i+PMDescW-1) end
        end
        for _,fn in ipairs(FuncNames) do fnl = fnl..(p[fn] and fn:sub(1,1)or ".") end
        items[#items+1] = {from=p,grayed=not Area.Shell,pos="N"..p.Info.Guid,text=frm:format(fnl,(p.Info.Title or ""),FN[1] or "",D[1] or "")}
        if oldpos==items[#items].pos then pos = #items end
        for j=2,math.max(#FN,#D) do items[#items+1] = {from=p,grayed=not Area.Shell,pos="N"..p.Info.Guid,text=frm:format("","",FN[j]or"",D[j]or"")} end
      end
    end
  end --for c in S.Show.Order:gmatch(".") do
  local title = "" for c in S.Show.Order:gmatch(".") do
    if c=="M" and S.Show.M then title = title..(L.TitleMac..(hf..af..S.Filter.K=="" and "" or "*")..".") end
    if c=="K" and S.Show.K then title = title..(L.TitleKey..(hf..af..S.Filter.K=="" and "" or "*")..".") end
    if c=="E" and S.Show.E then title = title..(L.TitleEvents..(gf=="" and "" or "*")..".") end
    if c=="O" and S.Show.O then title = title..(L.TitleModules..pf..".") end
    if c=="I" and S.Show.I then title = title..(L.TitleMenuItems..(hf..af=="" and "" or "*")..".") end
    if c=="P" and S.Show.P then title = title..(L.TitlePrefixes..prf..".") end
    if c=="N" and S.Show.N then title = title..(L.TitlePanels..pnf..".") end
  end
  if S.Filter.F~="*" then title = title..(L.diEdit.Mask:sub(4)..' "'..S.Filter.F:match("[^\n]*$")..'".') end
  local breaks,bottom,item = {{BreakKey="F1"},{BreakKey="F3"},le and {BreakKey="A+F3"},{BreakKey="F4"},{BreakKey="A+F4"},{BreakKey="C+F4"},
    {BreakKey="INSERT"},{BreakKey="NUMPAD0"},{BreakKey="DELETE"},{BreakKey="DECIMAL"},{BreakKey="C+NEXT"},{BreakKey="C+NUMPAD3"},{BreakKey="F9"},
    rb and {BreakKey="C+R"},(rb or #modules>0) and {BreakKey="C+D"},{BreakKey="A+F"},{BreakKey="C+A"},{BreakKey="A+L"},{BreakKey="C+L"},
    {BreakKey="S+M"},{BreakKey="S+E"},{BreakKey="S+O"},{BreakKey="S+I"},{BreakKey="S+P"},{BreakKey="S+N"},
    {BreakKey="C+M"},{BreakKey="CA+M"},{BreakKey="C+E"},{BreakKey="CA+E"},{BreakKey="C+O"},{BreakKey="CA+O"},
    {BreakKey="C+K"},{BreakKey="CS+K"},{BreakKey="CA+K"},{BreakKey="C+F"},{BreakKey="CS+F"},{BreakKey="CA+F"},rs and {BreakKey="C+S"},
    {BreakKey="A+M"},{BreakKey="A+K"},{BreakKey="A+H"},{BreakKey="A+E"},{BreakKey="A+O"},{BreakKey="A+I"},{BreakKey="A+P"},{BreakKey="A+N"}},
    "Enter,Esc,F1,F3,"..(le and "AltF3," or "").."F4,Alt/CtrlF4,Ins,Del,CtrlPgDn"..(rb and ",CtrlR/D" or "")..",F9"
  local res,menupos = far.Menu({Title=title,Bottom=bottom,Flags=F.FMENU_WRAPMODE+F.FMENU_SHOWAMPERSAND,SelectIndex=pos,Id=Guids.Menu},items,breaks)
  if not res then break end -- Esc/Break. "работаем, пока не надоест"? Надоело...
  if items[menupos] then oldpos,item = items[menupos].pos,items[menupos].from end-- запомним позицию курсора, пункт меню
  if res.BreakKey then -- не Enter или Esc?
    if res.BreakKey=="F1" then -- F1 - выведем справку
      ShowHelp("main")
    elseif item and res.BreakKey=="F3" then -- смотреть?
      local ttl = item.Info and L.diShowPanelModule or(item.guid and L.diShowMenuItem or(item.prefix and L.diShowCommandLine or
                   (item.name and L.diShowModule or(item.group and L.diShowEvent or(item.code and L.diShowKeyMacro or L.diShowMacro)))))
      if DoIt(ShowInfo,ttl,item) then break end -- сделаем и выйдем (если после действия надо завершить)
    elseif res.BreakKey=="A+F3" then -- открыть в LuaExplorer?
      item.descr = nil le(item) -- сделаем
    elseif item and res.BreakKey=="F4" then -- редактировать в диалоге?
      if item.Info then -- панельный модуль?
        DoIt(OpenPanelModuleInDialog,L.diEditPanelModule,item) -- сделаем
      elseif item.prefix then -- префикс?
        DoIt(OpenPrefixInDialog,L.diEditCommandLine,item) -- сделаем
      elseif item.guid then -- пункт меню плагинов?
        DoIt(OpenMenuItemInDialog,L.diEditMenuItem,item) -- сделаем
      elseif item.name then -- модуль?
        DoIt(OpenInEditor,L.edEditModule,item,false) -- сделаем
      elseif item.group then -- обработчик событий
        DoIt(OpenEventInDialog,L.diEditEvent,item) -- сделаем
      elseif item.code then -- клавиатурный огрызок?
        DoIt(OpenInternalMacroInDialog,L.diEditKeyMacro,item) -- сделаем
      elseif item.area then -- макрос?
        DoIt(OpenMacroInDialog,L.diEditMacro,item) -- сделаем
      end
    elseif item and regex.find(res.BreakKey,[[^(A|C)\+F4$]]) then -- редактировать во встроенном редакторе?
      DoIt(OpenInEditor,L["edEdit"..GetType(item)],item,res.BreakKey=="C+F4") if res.BreakKey=="C+F4" then break end -- сделаем
    elseif res.BreakKey=="INSERT" or res.BreakKey=="NUMPAD0" then -- добавить новый?
      DoIt(CreateNew,L.CreateNew,item or {}) -- сделаем
    elseif item and res.BreakKey=="DELETE" or res.BreakKey=="DECIMAL" then -- удалить текущий?
      DoIt(DeleteCurrent,L.DelElement,item) -- сделаем
    elseif item and (res.BreakKey=="C+NEXT" or res.BreakKey=="C+NUMPAD3") then -- перейти к файлу в панели?
      if not Area.Shell then ErrMess(L.er.NotFilePanel,L.goFile) -- не панель? низзя!
      elseif item.FileName then Panel.SetPath(0,item.FileName:match("(.*)\\([^\\]*)")) break -- перешли, всё
      else ErrMess(L[GetType(item)].." "..(item.descr or item.name or item.prefix)..". "..L.er.NoFile,L.goFile) end
    elseif item and res.BreakKey=="C+R" then -- переназначить клавишу с помощью Rebind?
      DoIt(Rebind,L.Rebind,item) -- переназначим
    elseif item and res.BreakKey=="C+D" then -- включить/выключить скрипт?
      DoIt(Disable,L.Disable,item) -- переназначим
    elseif item and res.BreakKey=="C+S" then -- открыть в ScriptBrowser?
      local info = rs.getscript_byfile(item.FileName) -- поищем info для данного файла
      if info then -- нашли?
        while info.parent_id do info = rs.getscript(info.parent_id) end -- найдём родителя
        local files = {info.FileName} -- список файлов, входящих в пакет
        for _,i in ipairs(rs.scripts) do if i.parent_id==info.id then files[#files+1] = i.FileName end end -- заполним список
      S.Filter.F = table.concat(files,",")..L.PkgFilter..info.description -- изменим маску файла
      else -- не нашли
        ErrMess(L.er.NoNFO,item.descr) -- так и скажем
      end
    elseif res.BreakKey=="F9" then -- настройка параметров?
      Config()
    elseif regex.find(res.BreakKey,[[^S\+(M|E|O|I|P|N)$]]) then -- редактировать порядок сортировки?
      local tL,C = {M=L.cbMacroSortVariants,E=L.cbEventSortVariants,O=L.cbModuleSortVariants,I=L.cbMISortVariants,P=L.cbPrefixSortVariants,
                    N=L.cbPMSortVariants},res.BreakKey:sub(3) S.SO[C] = SortingOrder(S.SO[C],tL[C])
    elseif res.BreakKey=="C+K" then -- редактировать фильтр клавиш?
      S.Filter.K = MacroKey()
    elseif res.BreakKey=="CS+K" then -- вручную указать маску клавиш?
      local M = far.InputBox(nil,"",L.InputKeyMask,"LMKeyMaskHistory",S.Filter.K,nil,nil,F.FIB_BUTTONS+F.FIB_ENABLEEMPTY+F.FIB_EXPANDENV)
      if M then S.Filter.K = M end -- если ввели маску, запомним новую
    elseif res.BreakKey=="CA+K" then -- отменить фильтр клавиш?
      S.Filter.K = S.SavedFilter.K
    elseif res.BreakKey=="C+M" then -- редактировать фильтр областей?
      S.Filter.A = SetFilter(S.Filter.A,L.AreaItems)
    elseif res.BreakKey=="CA+M" then -- сбросить фильтр областей?
      S.Filter.A = S.SavedFilter.A
    elseif res.BreakKey=="C+E" then -- редактировать фильтр групп?
      S.Filter.G,res = SetFilter(S.Filter.G,L.GroupItems)
      if res then S.Show.E = true end -- включим показ обработчиков событий
    elseif res.BreakKey=="CA+E" then -- сбросить фильтр групп?
      S.Filter.G = S.SavedFilter.G
    elseif res.BreakKey=="C+O" then -- редактировать фильтр путей поиска модулей?
      S.Filter.P,res = SetFilter(S.Filter.P,L.PathItems)
      if res then S.Show.O = true end -- включим показ модулей
    elseif res.BreakKey=="CA+O" then -- сбросить фильтр путей поиска модулей?
      S.Filter.P = S.SavedFilter.P
    elseif item and res.BreakKey=="C+F" then -- показывать только из того же файла?
      S.Filter.F = item.FileName or "*" -- изменим маску файла
    elseif res.BreakKey=="CS+F" then -- показывать только из файлов по маске?
      local M = S.Filter.F=="*" and "*.*" or S.Filter.F -- текущая маска
      M = far.InputBox(nil,"",L.InputFileMask,"LMFileMaskHistory",M,nil,nil,F.FIB_BUTTONS+F.FIB_ENABLEEMPTY+F.FIB_EXPANDENV) -- введём новую
      if M then -- если ввели маску
        if M=="" then M = "*.*" end -- приведём пустую маску к виду "все имена"
        if not M:match("[^\\]*$"):find(".",1,true) then M = M..".lua;"..M..".moon" end -- нет расширения? добавим стандартные
        S.Filter.F = M=="*.*" and "*" or M -- запомним новую маску (приведя маску "все имена" к удобному виду)
      end
    elseif res.BreakKey=="CA+F" then -- показывать из всех файлов?
      S.Filter.F = S.SavedFilter.F -- сбросим маску файла
    elseif regex.find(res.BreakKey,[[^A\+(M|K|E|O|I|P|N|H)$]]) then -- скрывать/показывать?
      local C = res.BreakKey:sub(3) S.Show[C] = not S.Show[C]
    elseif res.BreakKey=="A+F" then -- скрывать/показывать имена файлов?
      S.MaxFileWidth = S.MaxFileWidth==0 and 1000 or 0
    elseif res.BreakKey=="C+L" then -- сбросить настройки на сохранённые?
      LoadSettings()
    elseif res.BreakKey=="A+L" then -- восстановить последние фильтры?
      if LastFilter then S.Filter,LastFilter = LastFilter,nil end
    elseif res.BreakKey=="C+A" then -- Всё показать?
      local AllModules = ('"'..package.path..";"..package.moonpath..";"..package.cpath..'"'):gsub(";",'" "')
      S.Filter,S.Show = {A=Def.AreaFilter,K="",G=Def.GroupFilter,P=AllModules,F="*"},{M=true,K=true,E=true,O=true,I=true,P=true,F=true,N=true}
    end
  elseif item then -- Enter
    if item.prefix then
      local param = far.InputBox(nil,item.prefix..":",L.InputParam,"LMPrefixParamHistory","") -- выполним
      if param then mf.postmacro(item.action,item.prefix,param) break end -- выполним
    elseif item.guid then -- пункт меню плагинов?
      mf.postmacro(item.action,F.OPEN_PLUGINSMENU,0) break -- выполним
    elseif item.code then -- клавиатурный огрызок?
      eval(item.code,0) break -- выполним
    elseif item.area then -- макрос?
      if not item.condition or item.condition() then mf.postmacro(item.action) break end -- выполним
    end
  end
until false
LastFilter,S.Filter = S.Filter,{A=S.SavedFilter.A,G=S.SavedFilter.G,P=S.SavedFilter.P,K=S.SavedFilter.K,F=S.SavedFilter.F} -- для сбрасывания к ним
end
--
if type(nfo)=="table" then nfo.execute = function() ManageMacrosEvents() end end
--
return setmetatable({ -- что возвращает модуль
  Main = ManageMacrosEvents;
  Config = Config;
  InsertScript = function(stype) if Area.Editor then InsertScriptIntoEditor(stype) else ErrMess(L.er.NotEditor) end end;
  EditScript = function(line) if Area.Editor then EditScriptUnderCursor(line) else ErrMess(L.er.NotEditor) end end;
  InsUid = function() mf.print(GenUid()) end;
  Reload = Reload;
},{__call=function(self,...) return self.Main(...) end;})
