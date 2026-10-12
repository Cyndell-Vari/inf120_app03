unit ucadena;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  MAX_ELE = 255;

type

  { Cadena }

  Cadena = class
    private
      elem: array[1..MAX_ELE] of char;
      dim: integer;
      function esSep(c: char): boolean;
      procedure ubicarPal(n: integer; out ini, fin: integer);
      procedure insTexto(pos: integer; s: string);
      procedure elimRango(a, b: integer);
    public
      constructor crear();
      procedure limpiar();
      procedure cargar(s: string);
      function mostrarStr(): string;
      function getDim(): integer;
      function hayLugar(cant: integer): boolean;


      procedure addChar(c: char);
      procedure insChar(pos: integer; c: char);
      procedure elimChar(pos: integer);
      procedure interChar(p1, p2: integer);
      function cantChar(c: char): integer;
      function getChar(pos: integer): char;
      function busqChar(c: char): integer;


      function cantPal(): integer;
      function getPal(pos: integer): string;
      procedure insPal(pos: integer; pal: string);
      procedure elimPal(pos: integer);
      procedure cambPal(pos: integer; pal: string);
      function buscPal(pal: string): integer;
      procedure addPal(pal: string);

      procedure invertir();
      procedure rotar(n: integer);
      procedure mayusculas();
      procedure minusculas();
      procedure Titulo();
    end;

implementation

{ Cadena }

constructor Cadena.crear();
begin
  limpiar();
end;

procedure Cadena.limpiar();
var
  i: integer;
begin
  dim := 0;
  for i := 1 to MAX_ELE do
    elem[i] := ' ';
end;

procedure Cadena.cargar(s: string);
var
  i: integer;
begin
  limpiar();
  dim := Length(s);
  if dim > MAX_ELE then
    dim := MAX_ELE;
  for i := 1 to dim do
    elem[i] := s[i];
end;

function Cadena.mostrarStr(): string;
var
  i: integer;
  s: string;
begin
  s := '';
  for i := 1 to dim do
    s := s + elem[i];
  Result := s;
end;

function Cadena.getDim(): integer;
begin
  Result := dim;
end;

function Cadena.hayLugar(cant: integer): boolean;
begin
  Result := (dim + cant) <= MAX_ELE;
end;

function Cadena.esSep(c: char): boolean;
begin
  Result := (c = ' ');
end;
procedure Cadena.ubicarPal(n: integer; out ini, fin: integer);
var
  i, cont, comienzo: integer;
begin
  ini := 0;
  fin := 0;
  cont := 0;
  i := 1;
  while i <= dim do
  begin
    while (i <= dim) and esSep(elem[i]) do
      i := i + 1;
    if i <= dim then
    begin
      comienzo := i;
      while (i <= dim) and (not esSep(elem[i])) do
        i := i + 1;
      cont := cont + 1;
      if cont = n then
      begin
        ini := comienzo;
        fin := i - 1;
        Exit;
      end;
    end;
  end;
end;
procedure Cadena.insTexto(pos: integer; s: string);
var
  i, k: integer;
begin
  k := Length(s);
  if k = 0 then
    Exit;
  if not hayLugar(k) then
    Exit;
  if pos < 1 then
    pos := 1;
  if pos > dim + 1 then
    pos := dim + 1;

  for i := dim downto pos do
    elem[i + k] := elem[i];
  for i := 1 to k do
    elem[pos + i - 1] := s[i];
  dim := dim + k;
end;
procedure Cadena.elimRango(a, b: integer);
var
  i, k: integer;
begin
  if a < 1 then
    a := 1;
  if b > dim then
    b := dim;
  if a > b then
    Exit;
  k := b - a + 1;
  for i := b + 1 to dim do
    elem[i - k] := elem[i];
  dim := dim - k;
end;
procedure Cadena.addChar(c: char);
begin
  if dim < MAX_ELE then
  begin
    dim := dim + 1;
    elem[dim] := c;
  end;
end;
procedure Cadena.insChar(pos: integer; c: char);
begin
  insTexto(pos, c);
end;
procedure Cadena.elimChar(pos: integer);
begin
  if (pos >= 1) and (pos <= dim) then
    elimRango(pos, pos);
end;
procedure Cadena.interChar(p1, p2: integer);
var
  aux: char;
begin
  if (p1 >= 1) and (p1 <= dim) and (p2 >= 1) and (p2 <= dim) then
  begin
    aux := elem[p1];
    elem[p1] := elem[p2];
    elem[p2] := aux;
  end;
end;
function Cadena.cantChar(c: char): integer;
var
  i, cont: integer;
begin
  cont := 0;
  for i := 1 to dim do
    if elem[i] = c then
      cont := cont + 1;
  Result := cont;
end;
function Cadena.getChar(pos: integer): char;
begin
  if (pos >= 1) and (pos <= dim) then
    Result := elem[pos]
  else
    Result := #0;
end;
function Cadena.busqChar(c: char): integer;
var
  i: integer;
begin
  Result := 0;
  i := 1;
  while (i <= dim) and (Result = 0) do
  begin
    if elem[i] = c then
      Result := i;
    i := i + 1;
  end;
end;
function Cadena.cantPal(): integer;
var
  i, cont: integer;
begin
  cont := 0;
  i := 1;
  while i <= dim do
  begin
    while (i <= dim) and esSep(elem[i]) do
      i := i + 1;
    if i <= dim then
    begin
      cont := cont + 1;
      while (i <= dim) and (not esSep(elem[i])) do
        i := i + 1;
    end;
  end;
  Result := cont;
end;
function Cadena.getPal(pos: integer): string;
var
  ini, fin, i: integer;
  s: string;
begin
  s := '';
  ubicarPal(pos, ini, fin);
  if ini > 0 then
    for i := ini to fin do
      s := s + elem[i];
  Result := s;
end;
procedure Cadena.insPal(pos: integer; pal: string);
var
  ini, fin: integer;
begin
  pal := Trim(pal);
  if pal = '' then
    Exit;
  if not hayLugar(Length(pal) + 1) then
    Exit;
  if pos < 1 then
    pos := 1;

  if pos > cantPal() then
    addPal(pal)
  else
  begin
    ubicarPal(pos, ini, fin);
    insTexto(ini, pal + ' ');
  end;
end;
procedure Cadena.elimPal(pos: integer);
var
  ini, fin: integer;
begin
  ubicarPal(pos, ini, fin);
  if ini = 0 then
    Exit;
  if fin < dim then
    elimRango(ini, fin + 1)
  else if ini > 1 then
    elimRango(ini - 1, fin)
  else
    elimRango(ini, fin);
end;
procedure Cadena.cambPal(pos: integer; pal: string);
var
  ini, fin: integer;
begin
  pal := Trim(pal);
  if pal = '' then
    Exit;
  ubicarPal(pos, ini, fin);
  if ini = 0 then
    Exit;
  if (dim - (fin - ini + 1) + Length(pal)) > MAX_ELE then
    Exit;
  elimRango(ini, fin);
  insTexto(ini, pal);
end;
function Cadena.buscPal(pal: string): integer;
var
  i, n: integer;
begin
  Result := 0;
  pal := LowerCase(Trim(pal));
  n := cantPal();
  i := 1;
  while (i <= n) and (Result = 0) do
  begin
    if LowerCase(getPal(i)) = pal then
      Result := i;
    i := i + 1;
  end;
end;
procedure Cadena.addPal(pal: string);
var
  necesita: integer;
begin
  pal := Trim(pal);
  if pal = '' then
    Exit;
  necesita := Length(pal);
  if (dim > 0) and (not esSep(elem[dim])) then
    necesita := necesita + 1;
  if not hayLugar(necesita) then
    Exit;

  if (dim > 0) and (not esSep(elem[dim])) then
    addChar(' ');
  insTexto(dim + 1, pal);
end;
procedure Cadena.invertir();
var
  i: integer;
  aux: char;
begin
  for i := 1 to dim div 2 do
  begin
    aux := elem[i];
    elem[i] := elem[dim - i + 1];
    elem[dim - i + 1] := aux;
  end;
end;
procedure Cadena.rotar(n: integer);
var
  i, nuevo: integer;
  aux: array[1..MAX_ELE] of char;
begin
  if dim = 0 then
    Exit;
  n := n mod dim;
  if n < 0 then
    n := n + dim;
  if n = 0 then
    Exit;

  for i := 1 to dim do
    aux[i] := elem[i];
  for i := 1 to dim do
  begin
    nuevo := ((i - 1 + n) mod dim) + 1;
    elem[nuevo] := aux[i];
  end;
end;
procedure Cadena.mayusculas();
var
  i: integer;
begin
  for i := 1 to dim do
    if (elem[i] >= 'a') and (elem[i] <= 'z') then
      elem[i] := Chr(Ord(elem[i]) - 32);
end;
procedure Cadena.minusculas();
var
  i: integer;
begin
  for i := 1 to dim do
    if (elem[i] >= 'A') and (elem[i] <= 'Z') then
      elem[i] := Chr(Ord(elem[i]) + 32);
end;
procedure Cadena.Titulo();
var
  i: integer;
  nueva: boolean;
begin
  minusculas();
  nueva := True;
  for i := 1 to dim do
  begin
    if esSep(elem[i]) then
      nueva := True
    else
    begin
      if nueva and (elem[i] >= 'a') and (elem[i] <= 'z') then
        elem[i] := Chr(Ord(elem[i]) - 32);
      nueva := False;
    end;
  end;
end;
end.
