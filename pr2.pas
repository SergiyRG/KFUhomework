program Project1;
 
type
  {Тип основных данных.}
  TData = Integer;
  {Тип, описывающий указатель на элемент.}
  TPElem = ^TElem;
  {Тип, описывающий элемент списка.}
  TElem = record
    Data : TData;
    PNext : TPElem; {Указатель на следующий элемент.}
  end;
  {Тип, описывающий список.}
  TDList = record
    PFirst, PLast : TPElem; {Указатели на первый и на последний элементы списка.}
  end;
 
{Процедуры для работы со списком.}
 
{Начальная инициализация списка. Внимание! Эту процедуру можно выполнять
только в отношении пустого списка. Иначе будут утечки памяти.}
procedure Init(var aL : TDList);
begin
  aL.PFirst := nil;
  aL.PLast := nil;
end;
 
{Освобождение памяти, занятой для элементов списка и инициализация.}
procedure LFree(var aL : TDList);
var
  P, PDel : TPElem;
begin
  P := aL.PFirst; {Указатель на первый элемент списка.}
  while P <> nil do
  begin
    PDel := P; {Запоминаем указатель на текущий элемент.}
    P := P^.PNext; {Получаем указатель на следующий элемент.}
    Dispose(PDel); {Освобождаем память, занятую текущим элементом списка.}
  end;
  Init(aL);
end;
 
{Добавление элемента в список согласно сортировочному правилу - по невозрастанию,
в данном случае.}
procedure AddDesc(var aL : TDList; const aData : TData);
var
  PNew, PCur, PPrev : TPElem;
begin
  New(PNew); {Выделяем паямять для элемента.}
  PNew^.Data := aData; {Записываем данные.}
  {Ищем элемент, который меньше или равен новому - перед ним следует вставить
  новый элемент.}
  PCur := aL.PFirst;{Указатель на текущий элемент.}
  {Указатель на предыдущий элемент. Этот указатель мы должны знать для того,
  чтобы мы могли вставить новый элемент между PPrev и PCur.}
  PPrev := nil;
  while (PCur <> nil) and (PCur^.Data > aData) do
  begin
    PPrev := PCur;
    PCur := PCur^.PNext;
  end;
  {Теперь, в зависимости от результатов поиска выполняем вставку нового элемента
  в нужное место списка.}
  PNew^.PNext := PCur;
  if PPrev <> nil then {Добавление между PPrev и PCur, либо - в конец списка.}
    PPrev^.PNext := PNew
  else {Добавление в начало списка.}
    aL.PFirst := PNew;
  if PNew^.PNext = nil then {Если новый элемент стал последним элементом в списке.}
    aL.PLast := PNew;
end;
 
{Распечатка списка.}
procedure LWriteln(const aL : TDList);
var
  P : TPElem;
begin
  P := aL.PFirst; {Указатель на первый элемент списка.}
  if P <> nil then
  repeat
    {Если это не первый элемент, то в распечатке ставим перед ним запятую.}
    if P <> aL.PFirst then
      Write(', ');
    Write(P^.Data); {Распечатываем данные текущего элемента.}
    P := P^.PNext; {Получаем указатель на следующий элемент.}
  until P = nil
  else
    Write('Список пуст.');
  Writeln;
end;
 
const
  M = 5; {Количество элементов, которые мы будем добавлять в списки.}
var
  L1, L2, L3 : TDList;
  P : TPElem;
  i : Integer;
  S : String;
begin
  {Начальная инициализация списков.}
  Init(L1);
  Init(L2);
  Init(L3);
 
  repeat
    {Создаём исходные списки.}
    Randomize; {Инициализируем генератор случайных чисел.}
    for i := 1 to M do
    begin
      AddDesc(L1, Random(100)); {Случайные целые числа из диапазона: 0..99.}
      AddDesc(L2, Random(100));
    end;
    Writeln('Заданы списки: ');
    LWriteln(L1);
    LWriteln(L2);
 
    {Выполняем слияние исходных списков в результирующий.}
    {Слияние первого списка.}
    P := L1.PFirst;
    while P <> nil do
    begin
      AddDesc(L3, P^.Data);
      P := P^.PNext;
    end;
    {Слияние второго списка.}
    P := L2.PFirst;
    while P <> nil do
    begin
      AddDesc(L3, P^.Data);
      P := P^.PNext;
    end;
 
    {Ответ.}
    Writeln('Результат слияния:');
    LWriteln(L3);
 
    {Освобождение памяти, занятой для элементов списков.}
    LFree(L1);
    LFree(L2);
    LFree(L3);
    Writeln('Память, выделенная для списков - освобождена.');
 
    Writeln('Повторить - Enter, выход - любой символ + Enter.');
    Readln(S);
  until S <> '';
end.
