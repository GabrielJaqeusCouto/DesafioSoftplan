unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB;

type
  TServidor = class
  private
    FPath: AnsiString;
  public
    constructor Create;
    //Tipo do par�metro n�o pode ser alterado
    procedure SalvarArquivos(AData: OleVariant);

  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure AtualizaProBar(qtdAndamento: Integer);
  private
    FPath: AnsiString;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  cds := InitDataset;
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    AtualizaProBar(i);

    cds.Append;
    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(string(FPath));
    cds.Post;

    {$REGION Simula��o de erro, n�o alterar}
    if i = (QTD_ARQUIVOS_ENVIAR/2) then
      FServidor.SalvarArquivos(NULL);
    {$ENDREGION}
  end;

  FServidor.SalvarArquivos(cds.Data);
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  for i := 0 to QTD_ARQUIVOS_ENVIAR do
  begin
    Sleep(100);

    cds := InitDataset;
    try
      AtualizaProBar(i);

      if FileExists(string(FPath)) then
      begin
        if cds.State in [dsInsert,dsEdit] then
          ShowMessage('teste');

        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(string(FPath));
        cds.Post;
      end;

      FServidor.SalvarArquivos(cds.Data);
    finally
      FreeAndNil(cds);
    end;
  end;


end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := AnsiString(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))) + 'pdf.pdf';
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := AnsiString(ExtractFilePath(ParamStr(0))) + 'Servidor\';
end;

procedure TServidor.SalvarArquivos(AData: OleVariant);
var
  cds: TClientDataSet;
  FileName: string;
begin
  try
    cds := TClientDataset.Create(nil);
    try
      cds.Data := AData;

      {$REGION Simula��o de erro, n�o alterar}
      if cds.RecordCount = 0 then
        Exit;
      {$ENDREGION}

      cds.First;

      while not cds.Eof do
      begin
        FileName := string(FPath) + cds.RecNo.ToString + '.pdf';
        if TFile.Exists(FileName) then
          TFile.Delete(FileName);

        TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
        cds.Next;
      end;
    finally
      FreeAndNil(cds);
    end;


  except
    raise;
  end;
end;

procedure TfClienteServidor.AtualizaProBar(qtdAndamento: Integer);
begin
  ProgressBar.Position := qtdAndamento;
end;

end.