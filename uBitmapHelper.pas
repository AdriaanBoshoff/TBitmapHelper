unit uBitmapHelper;

interface

uses
  System.Types, System.Classes, FMX.Graphics, IdHTTP, IdSSLOpenSSL;

type
  TDownloadImage = class(TThread)
  private
    url: string;
    bitmap: TBitmap;
  public
    constructor Create(const aURL: string; const aBitmap: TBitmap);
  protected
    procedure Execute; override;
  end;

type
  TBitmapHelper = class helper for TBitmap
    procedure DownloadImage(const aURL: string);
  end;

implementation

{ TDownloadImage }

constructor TDownloadImage.Create(const aURL: string; const aBitmap: TBitmap);
begin
  inherited Create(True);
  bitmap := aBitmap;
  url := aURL;
end;

procedure TDownloadImage.Execute;
var
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
  memstream: TMemoryStream;
begin
  http := TIdHTTP.Create(nil);
  try
    http.Request.UserAgent := 'BitmapHelper/1.0 Bitmap Helper';
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      ssl.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
      http.IOHandler := ssl;

      memstream := TMemoryStream.Create;
      try
        http.Get(url, memstream);
        Synchronize(
          procedure
          begin
            bitmap.LoadFromStream(memstream);
          end);
      finally
        memstream.Free;
      end;
    finally
      ssl.Free;
    end;
  finally
    http.Free;
  end;
end;

{ TBitmapHelper }

procedure TBitmapHelper.DownloadImage(const aURL: string);
var
  athread: TDownloadImage;
begin
  athread := TDownloadImage.Create(aURL, Self);
  athread.FreeOnTerminate := True;
  athread.Start;
end;

end.

