unit ufcadena;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ucadena;

type

  { TForm1 }

  TForm1 = class(TForm)
    gbDatos: TGroupBox;
    gbChar: TGroupBox;
    gbPal: TGroupBox;
    gbOtros: TGroupBox;
    lblCadena: TLabel;
    lblLargo: TLabel;
    lblTexto: TLabel;
    lblPos: TLabel;
    lblPos2: TLabel;
    lblRes: TLabel;
    edtCadena: TEdit;
    edtTexto: TEdit;
    edtPos: TEdit;
    edtPos2: TEdit;
    edtResultado: TEdit;
    btnCargar: TButton;
    btnLimpiar: TButton;
    btnAddChar: TButton;
    btnInsChar: TButton;
    btnElimChar: TButton;
    btnInterChar: TButton;
    btnCantChar: TButton;
    btnGetChar: TButton;
    btnBusqChar: TButton;
    btnCantPal: TButton;
    btnInsPal: TButton;
    btnElimPal: TButton;
    btnCambPal: TButton;
    btnBuscPal: TButton;
    btnAddPal: TButton;
    btnInvertir: TButton;
    btnRotar: TButton;
    btnMayusculas: TButton;
    btnMinusculas: TButton;
    btnTitulo: TButton;
    procedure btnAddCharClick(Sender: TObject);
    procedure btnAddPalClick(Sender: TObject);
    procedure btnBuscPalClick(Sender: TObject);
    procedure btnBusqCharClick(Sender: TObject);
    procedure btnCambPalClick(Sender: TObject);
    procedure btnCantCharClick(Sender: TObject);
    procedure btnCantPalClick(Sender: TObject);
    procedure btnCargarClick(Sender: TObject);
    procedure btnElimCharClick(Sender: TObject);
    procedure btnElimPalClick(Sender: TObject);
    procedure btnGetCharClick(Sender: TObject);
    procedure btnInsCharClick(Sender: TObject);
    procedure btnInsPalClick(Sender: TObject);
    procedure btnInterCharClick(Sender: TObject);
    procedure btnInvertirClick(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure btnMayusculasClick(Sender: TObject);
    procedure btnMinusculasClick(Sender: TObject);
    procedure btnRotarClick(Sender: TObject);
    procedure btnTituloClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    C: Cadena;
    procedure Refrescar();
    function EsASCII(s: string): boolean;
    function LeerEntero(edt: TEdit; out n: integer): boolean;
    function LeerPos(edt: TEdit; maximo: integer; out n: integer): boolean;
    function LeerChar(out ch: char): boolean;
    function LeerPalabra(out s: string): boolean;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  C := Cadena.crear();
  edtCadena.ReadOnly := True;
  edtResultado.ReadOnly := True;
  edtTexto.Text := '';
  edtPos.Text := '';
  edtPos2.Text := '';
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  C.Free;
end;

procedure TForm1.Refrescar();
begin
  edtCadena.Text := C.mostrarStr();
  lblLargo.Caption := 'Largo: ' + IntToStr(C.getDim()) + ' / ' + IntToStr(MAX_ELE);
end;

function TForm1.EsASCII(s: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(s) do
    if Ord(s[i]) > 127 then
      Result := False;
end;

function TForm1.LeerEntero(edt: TEdit; out n: integer): boolean;
begin
  Result := TryStrToInt(Trim(edt.Text), n);
  if not Result then
  begin
    ShowMessage('Ingrese un número entero válido.');
    edt.SetFocus;
  end;
end;

function TForm1.LeerPos(edt: TEdit; maximo: integer; out n: integer): boolean;
begin
  Result := TryStrToInt(Trim(edt.Text), n) and (n >= 1) and (n <= maximo);
  if not Result then
  begin
    if maximo < 1 then
      ShowMessage('No hay elementos para esa operación.')
    else
      ShowMessage('La posición debe estar entre 1 y ' + IntToStr(maximo) + '.');
    edt.SetFocus;
  end;
end;

function TForm1.LeerChar(out ch: char): boolean;
begin
  ch := ' ';
  Result := (edtTexto.Text <> '') and EsASCII(edtTexto.Text);
  if not Result then
  begin
    ShowMessage('Escriba un carácter (sin tilde ni ñ) en "Texto / Palabra".');
    edtTexto.SetFocus;
  end
  else
    ch := edtTexto.Text[1];
end;

function TForm1.LeerPalabra(out s: string): boolean;
begin
  s := Trim(edtTexto.Text);
  Result := (s <> '') and (Pos(' ', s) = 0) and EsASCII(s);
  if not Result then
  begin
    ShowMessage('Escriba una sola palabra (sin espacios, tildes ni ñ) en "Texto / Palabra".');
    edtTexto.SetFocus;
  end;
end;
procedure TForm1.btnCargarClick(Sender: TObject);
begin
  if not EsASCII(edtTexto.Text) then
  begin
    ShowMessage('Use solo letras sin tilde ni ñ.');
    edtTexto.SetFocus;
    Exit;
  end;
  if Length(edtTexto.Text) > MAX_ELE then
    ShowMessage('Se cargarán solo los primeros ' + IntToStr(MAX_ELE) + ' caracteres.');

  C.cargar(edtTexto.Text);
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnLimpiarClick(Sender: TObject);
begin
  C.limpiar();
  edtTexto.Text := '';
  edtPos.Text := '';
  edtPos2.Text := '';
  edtResultado.Text := '';
  Refrescar();
  edtTexto.SetFocus;
end;
procedure TForm1.btnAddCharClick(Sender: TObject);
var
  c1: char;
begin
  if not LeerChar(c1) then
    Exit;
  if not C.hayLugar(1) then
  begin
    ShowMessage('La cadena está llena (máximo ' + IntToStr(MAX_ELE) + ').');
    Exit;
  end;
  C.addChar(c1);
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnInsCharClick(Sender: TObject);
var
  c1: char;
  pos: integer;
begin
  if not LeerPos(edtPos, C.getDim() + 1, pos) then
    Exit;
  if not LeerChar(c1) then
    Exit;
  if not C.hayLugar(1) then
  begin
    ShowMessage('La cadena está llena (máximo ' + IntToStr(MAX_ELE) + ').');
    Exit;
  end;
  C.insChar(pos, c1);
  edtResultado.Text := '';
  Refrescar();
end;
procedure TForm1.btnElimCharClick(Sender: TObject);
var
  pos: integer;
begin
  if not LeerPos(edtPos, C.getDim(), pos) then
    Exit;
  C.elimChar(pos);
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnInterCharClick(Sender: TObject);
var
  p1, p2: integer;
begin
  if not LeerPos(edtPos, C.getDim(), p1) then
    Exit;
  if not LeerPos(edtPos2, C.getDim(), p2) then
    Exit;
  C.interChar(p1, p2);
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnCantCharClick(Sender: TObject);
var
  c1: char;
begin
  if not LeerChar(c1) then
    Exit;
  edtResultado.Text := 'El carácter "' + c1 + '" aparece ' +
                       IntToStr(C.cantChar(c1)) + ' vez/veces.';
end;
procedure TForm1.btnGetCharClick(Sender: TObject);
var
  pos: integer;
begin
  if not LeerPos(edtPos, C.getDim(), pos) then
    Exit;
  edtResultado.Text := 'En la posición ' + IntToStr(pos) + ' está "' + C.getChar(pos) + '".';
end;
procedure TForm1.btnBusqCharClick(Sender: TObject);
var
  c1: char;
  p: integer;
begin
  if not LeerChar(c1) then
    Exit;
  p := C.busqChar(c1);
  if p = 0 then
    edtResultado.Text := 'El carácter "' + c1 + '" no está en la cadena.'
  else
    edtResultado.Text := 'Primera posición de "' + c1 + '": ' + IntToStr(p) + '.';
end;
procedure TForm1.btnCantPalClick(Sender: TObject);
begin
  edtResultado.Text := 'Cantidad de palabras: ' + IntToStr(C.cantPal()) + '.';
end;
procedure TForm1.btnInsPalClick(Sender: TObject);
var
  pos: integer;
  pal: string;
begin
  if not LeerPos(edtPos, C.cantPal() + 1, pos) then
    Exit;
  if not LeerPalabra(pal) then
    Exit;
  if not C.hayLugar(Length(pal) + 1) then
  begin
    ShowMessage('No hay lugar para la palabra (máximo ' + IntToStr(MAX_ELE) + ').');
    Exit;
  end;
  C.insPal(pos, pal);
  edtResultado.Text := '';
  Refrescar();
end;
procedure TForm1.btnElimPalClick(Sender: TObject);
var
  pos: integer;
begin
  if not LeerPos(edtPos, C.cantPal(), pos) then
    Exit;
  C.elimPal(pos);
  edtResultado.Text := '';
  Refrescar();
end;
procedure TForm1.btnCambPalClick(Sender: TObject);
var
  pos: integer;
  pal: string;
begin
  if not LeerPos(edtPos, C.cantPal(), pos) then
    Exit;
  if not LeerPalabra(pal) then
    Exit;
  if (C.getDim() - Length(C.getPal(pos)) + Length(pal)) > MAX_ELE then
  begin
    ShowMessage('No hay lugar para la palabra (máximo ' + IntToStr(MAX_ELE) + ').');
    Exit;
  end;
  C.cambPal(pos, pal);
  edtResultado.Text := '';
  Refrescar();
end;
procedure TForm1.btnBuscPalClick(Sender: TObject);
var
  pal: string;
  p: integer;
begin
  if not LeerPalabra(pal) then
    Exit;
  p := C.buscPal(pal);
  if p = 0 then
    edtResultado.Text := 'La palabra "' + pal + '" no está en la cadena.'
  else
    edtResultado.Text := 'La palabra "' + pal + '" es la número ' + IntToStr(p) + '.';
end;
procedure TForm1.btnAddPalClick(Sender: TObject);
var
  pal: string;
begin
  if not LeerPalabra(pal) then
    Exit;
  if not C.hayLugar(Length(pal) + 1) then
  begin
    ShowMessage('No hay lugar para la palabra (máximo ' + IntToStr(MAX_ELE) + ').');
    Exit;
  end;
  C.addPal(pal);
  edtResultado.Text := '';
  Refrescar();
end;
procedure TForm1.btnInvertirClick(Sender: TObject);
begin
  C.invertir();
  edtResultado.Text := '';
  Refrescar();
end;
procedure TForm1.btnRotarClick(Sender: TObject);
var
  n: integer;
begin
  if not LeerEntero(edtPos, n) then
    Exit;
  C.rotar(n);
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnMayusculasClick(Sender: TObject);
begin
  C.mayusculas();
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnMinusculasClick(Sender: TObject);
begin
  C.minusculas();
  edtResultado.Text := '';
  Refrescar();
end;

procedure TForm1.btnTituloClick(Sender: TObject);
begin
  C.Titulo();
  edtResultado.Text := '';
  Refrescar();
end;

end.
