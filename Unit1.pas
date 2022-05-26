unit Unit1;

interface

uses
  Windows, SysUtils, Variants, Classes, Controls, Forms,
  Series,
  TeeProcs, DbChart, TeEngine, ExtCtrls, StdCtrls, Chart, QRTEE, QuickRpt;

type
  TForm1 = class(TForm)
    Button1: TButton;
    btns: TEdit;
    btnx: TEdit;
    btnu: TEdit;
    btnr: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    btnn: TEdit;
    btnt: TEdit;
    btnresult: TEdit;
    btnelapsed: TEdit;
    btntimes: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button2: TButton;
    QRChart1: TQRChart;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Series1: TLineSeries;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
        math;


var n, callorput: integer; sigma, r, t, s, x, output: double;  t0, t1: dword;

function EuropeanOptionPrice(n, callorput: integer; sigma, r, t, s, x: double): double;
var k, j, m: integer; rt, rp, f, p, u, d: double;
begin
    rt:= 0;
    u:= exp(sigma*sqrt(t/n));
    d:= 1/u;
    p:= (exp(r*t/n)-d) / (u-d);
    for j:=0 to n do
    begin
        if callorput = 0 then f:= max(0, s*intpower(u, j)*intpower(d, n-j) - x )
            else f:= max(0, x - s*intpower(u, j)*intpower(d, n-j));
        if f > 0 then
        begin
            rp:= intpower(p, j) * intpower(1-p, n-j);
            if (n-j) < j then m:= n-j else m:= j;
            for k:=1 to m do rp:= rp * ((n-m+k)/k);
            rp:= rp * f;
            rt:= rt + rp;
        end;
    end;
    result:= rt * exp(-r*t);
end;

procedure TForm1.Button1Click(Sender: TObject);
var i: integer;
begin
    n:=strtoint(btnn.Text);
    if radiobutton1.Checked then callorput:=0 else callorput:=1;
    sigma:=strtofloat(btnu.Text);
    r:=strtofloat(btnr.Text);
    t:=strtofloat(btnt.Text);
    s:=strtofloat(btns.Text);
    x:=strtofloat(btnx.Text);

    button1.Enabled:=false;
    t0:= gettickcount;
    for i:=1 to strtoint(btntimes.Text) do output:= EuropeanOptionPrice(n,callorput, sigma,r,t,s,x);
    t1:= gettickcount;
    btnresult.Text:= floattostr(output);
    btnelapsed.Text:= inttostr( t1 - t0);
    button1.Enabled:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
var     i: integer;
begin                                   
    n:=strtoint(btnn.Text);
    if radiobutton1.Checked then callorput:=0 else callorput:=1;
    sigma:=strtofloat(btnu.Text);
    r:=strtofloat(btnr.Text);
    t:=strtofloat(btnt.Text);
    s:=strtofloat(btns.Text);
    x:=strtofloat(btnx.Text);

    button2.Enabled:=false;
    qrchart1.Chart.Series[0].Clear;
    t0:= gettickcount;
    for i:=1 to n do
        qrchart1.Chart.Series[0].Add(EuropeanOptionPrice(i,callorput, sigma,r,t,s,x), inttostr(i));
    t1:= gettickcount;
    btnresult.Text:= floattostr(EuropeanOptionPrice(n,callorput, sigma,r,t,s,x));
    btnelapsed.Text:= inttostr( t1 - t0);
    button2.Enabled:=true;
end;

end.
