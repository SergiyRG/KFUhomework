type	TED = integer;
	list =^ top;
	top = record
		elem: TED;
		l, r,next: list;
	end;

function сount(L:list;e:TED):integer; 
 {подсчитывает число вхождений элемента e в список L} 
begin   
  if L = nil then сount:=0       
  else сount:=сount(L^.next,e)+ord(L^.elem = e) 
end;

procedure insert(var L: list;e: integer);
begin
	if L = nil then begin
		new(L);
		L^.elem := e;
		L^.l := nil;
		L^.r := nil
	end
	else if random(2) = 1 then insert(L^.l,e) else insert(L^.r,e)
end;

procedure show(var L: list; h: integer);
begin
	if L <> nil then begin
		show(L^.r,h+1);
		write(L^.elem+' ');
		show(L^.l,h+1)
	end
end;



function count(L: list; x: integer): integer;
var	cons: integer;
begin
	cons := 0;
	if L <> nil then begin
		if L^.elem = x then inc(cons);
		cons := cons + count(L^.l,x)+count(L^.r,x);
	end;
	result:= cons
end;

procedure remove(var L: list);
begin
	if L <> nil then begin
		if L^.r <> nil then remove(L^.r);
		if L^.l <> nil then remove(L^.l);
		dispose(L)
	end
end;

var	e, n, i, r: integer;
	L: list;
begin
	write('Количество элементов в списке: ');
	readln(n);
	randomize;
	for i := 1 to n do begin
		r := random(100);
		insert(L,r)
	end;
	writeln('Список:');
	show(L,1);
	writeln;
	write('Искомый элемент: ');
	readln(e);
	writeln('Количество вхождений: ',count(L,e));
	remove(L);
end.
