unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfThreads = class(TForm)
    qtdThreads: TEdit;
    tmpThreads: TEdit;
    btnIniciar: TBitBtn;
    Memo: TMemo;
    procedure btnIniciarClick(Sender: TObject);
    procedure qtdThreadsKeyPress(Sender: TObject; var Key: Char);
    procedure tmpThreadsKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

{$R *.dfm}

procedure TfThreads.btnIniciarClick(Sender: TObject);
var
  i,
  j : Integer;
begin
  Memo.Clear;

  for i := 0 to StrToInt(qtdThreads.Text) do
  begin
    Sleep(Random(StrToInt(tmpThreads.Text)));

    TThread.CreateAnonymousThread(
      procedure
      var
        idThread: THandle;
      begin
        j := 0;
        idThread := GetCurrentProcessId();

        Memo.Lines.Append(idThread.ToString + ' � Iniciando processamento');
        while j < QTD_ARQUIVOS_ENVIAR  do
        begin
          j := j + 1
        end;
        Memo.Lines.Append(idThread.ToString + '� Iniciando finalizado');
      end
    ).Start;
  end;
end;

procedure TfThreads.qtdThreadsKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,['0'..'9',#8]) then
    key := #0;
end;

procedure TfThreads.tmpThreadsKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,['0'..'9',#8]) then
    key := #0;
end;

end.