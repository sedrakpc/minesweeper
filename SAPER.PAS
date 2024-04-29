program saper;
uses crt,graph,dos;
label 1;
type Str6=string[6];
var ch:char;
elh,elw:byte;
mset:set of byte;
count,x,y:word;
regs:registers;
i,j,n,m,r1,r2,co,col:byte;
button:byte;
mouse_ok,vin,newgame:boolean;
s:string;
masiv:array[0..19,1..19] of byte;
smasiv:array[1..18,1..18] of boolean;
omasiv:array[1..18,1..18] of boolean;
fmasiv:array[1..18,1..18] of boolean;
procedure reset_mouse(var mouse_ok:boolean;var button:byte);
begin
regs.ax:=$00;
intr($33,regs);
mouse_ok:=odd(regs.ax);
button:=regs.bx;end;
procedure show_cursor;
begin
regs.ax:=$01;
intr($33,regs);
end;
procedure hide_cursor;
begin
regs.ax:=$02;
intr($33,regs);
end;
procedure get_mouse_status(var button:byte;var x,y:word);
begin
regs.ax:=$03;
intr($33,regs);
with regs do begin
button:=bl;
x:=cx;y:=dx;end;
end;
procedure get_mouse_button_press(var button:byte;var count,x,y:word);
begin
regs.ax:=$05;
regs.bl:=button;
intr($33,regs);
with regs do begin
button:=al;count:=bx;
x:=cx;y:=dx;end;
end;
procedure init;
var GD,GM,EC:integer;
begin
GD:=detect;
initgraph(GD,GM,'c:\bp\bgi');
EC:=graphresult;
if EC <> grOK then
begin
Writeln(GraphErrorMsg(EC));
Halt(1);
end;
end;
procedure cub(x,y:integer);
begin
setfillstyle(1,7);
bar(x,y,x+elw,y+elh);
setfillstyle(1,8);
bar(x+2,y+2,x+elw-1,y+elh-1);
setcolor(8);
rectangle(x-1,y-1,x+elw+1,y+elh+1);
end;
procedure show(x,y:integer;k:byte);
begin
setfillstyle(1,7);
bar(x,y,x+elw,y+elh);
settextstyle(0,0,2);
case k of
9:begin setcolor(0);
setfillstyle(1,0);
fillellipse(x+10,y+10,5,5);
line(x+10,y+2,x+10,y+18);
line(x+2,y+10,x+18,y+10);
line(x+5,y+5,x+15,y+15);
line(x+5,y+15,x+15,y+5);
setfillstyle(1,15);
setcolor(15);
fillellipse(x+8,y+8,1,2);
end;
8:begin setcolor(8);outtextxy(x+4,y+3,'8');end;
7:begin setcolor(0);outtextxy(x+4,y+3,'7');end;
6:begin setcolor(11);outtextxy(x+4,y+3,'6');end;
5:begin setcolor(6);outtextxy(x+4,y+3,'5');end;
4:begin setcolor(5);outtextxy(x+4,y+3,'4');end;
3:begin setcolor(4);outtextxy(x+4,y+3,'3');end;
2:begin setcolor(2);outtextxy(x+4,y+3,'2');end;
1:begin setcolor(1);outtextxy(x+3,y+3,'1');end;
end;
end;
procedure show_zero(m,n:byte);
var x,y:integer;
begin
if (m>0) and (m<19) and (n>0) and (n<19) then begin
x:=80+m*22;
y:=20+n*21;
hide_cursor;
setfillstyle(1,7);
bar(x,y,x+elw,y+elh);
if not (n-1<1) then
if masiv[m,n-1]<>0 then begin
show(80+m*22,20+(n-1)*21,masiv[m,n-1]);omasiv[m,n-1]:= true;end
else if not smasiv[m,n-1] then
begin smasiv[m,n-1]:=true;
show_zero(m,n-1);end;
if not (n+1>18) then
if masiv[m,n+1]<>0 then begin
show(80+m*22,20+(n+1)*21,masiv[m,n+1]);omasiv[m,n+1]:=true;end
else
if not smasiv[m,n+1] then
begin smasiv[m,n+1]:=true;
show_zero(m,n+1);end;
if not (m-1<1) then
if masiv[m-1,n]<>0 then begin
show(80+(m-1)*22,20+n*21,masiv[m-1,n]);omasiv[m-1,n]:=true;end
else
if not smasiv[m-1,n] then
begin smasiv[m-1,n]:=true;
show_zero(m-1,n);end;
if not (m+1>18) then
if masiv[m+1,n]<>0 then begin
show(80+(m+1)*22,20+n*21,masiv[m+1,n]);omasiv[m+1,n]:=true;end
else
if not smasiv[m+1,n] then
begin smasiv[m+1,n]:=true;
show_zero(m+1,n);end;
if (not (n+1>18)) and (not (m+1>18)) then
if masiv[m+1,n+1]<>0 then begin
show(80+(m+1)*22,20+(n+1)*21,masiv[m+1,n+1]);omasiv[m+1,n+1]:=true;end
else
if not smasiv[m+1,n+1] then
begin smasiv[m+1,n+1]:=true;
show_zero(m+1,n+1);end;
if (not (n-1<1)) and (not (m+1>18)) then
if masiv[m+1,n-1]<>0 then begin
show(80+(m+1)*22,20+(n-1)*21,masiv[m+1,n-1]);omasiv[m+1,n-1]:=true;end
else
if not smasiv[m+1,n-1] then
begin smasiv[m+1,n-1]:=true;
show_zero(m+1,n-1);end;
if (not (n+1>18)) and (not (m-1<1)) then
if masiv[m-1,n+1]<>0 then begin
show(80+(m-1)*22,20+(n+1)*21,masiv[m-1,n+1]);omasiv[m-1,n+1]:=true;end
else
if not smasiv[m-1,n+1] then
begin smasiv[m-1,n+1]:=true;
show_zero(m-1,n+1);end;
if (not (n-1<1)) and (not (m-1<1)) then
if masiv[m-1,n-1]<>0 then begin
show(80+(m-1)*22,20+(n-1)*21,masiv[m-1,n-1]);omasiv[m-1,n-1]:=true;end
else
if not smasiv[m-1,n-1] then
begin smasiv[m-1,n-1]:=true;
show_zero(m-1,n-1);end;
show_cursor;
end;
end;
procedure show_wrong_flag(x,y:integer);
begin
setcolor(0);
line(x+10,y+5,x+10,y+15);
line(x+7,y+15,x+13,y+15);
setfillstyle(1,4);
bar(x+5,y+5,x+9,y+9);
line(x+4,y+4,x+11,y+11);
line(x+4,y+11,x+11,y+4);
end;
procedure show_all;
var i,j:byte;
begin
for i:=1 to 18 do
for j:=1 to 18 do
if (masiv[i,j]=9) and (fmasiv[i,j]=false) then show(80+i*22,20+j*21,masiv[i,j]);
for i:=1 to 18 do
for j:=1 to 18 do
if (fmasiv[i,j]=true) and (masiv[i,j]<>9) then
show_wrong_flag(80+i*22,20+j*21);
end;
procedure show_flag(x,y:integer);
begin
setcolor(0);
line(x+10,y+5,x+10,y+15);
line(x+7,y+15,x+13,y+15);
setfillstyle(1,4);
bar(x+5,y+5,x+9,y+9);
end;
procedure hide_flag(x,y:integer);
begin
cub(x,y);
end;
{//////////////////main\\\\\\\\\\\\\\\\\}
begin
init;
reset_mouse(mouse_ok,button);
if not mouse_ok then halt;
show_cursor;
elH:=19;
elW:=20;
1:co:=0;
col:=0;
hide_cursor;
newgame:=false;
for i:=0 to 19 do
for j:=0 to 19 do masiv[i,j]:=11;
for i:=1 to 18 do
for j:=1 to 18 do smasiv[i,j]:=false;
for i:=1 to 18 do
for j:=1 to 18 do omasiv[i,j]:=false;
for i:=1 to 18 do
for j:=1 to 18 do fmasiv[i,j]:=false;
randomize;
mset:=[];
for i:=1 to 59 do begin
repeat
r1:=random(18)+1;
r2:=random(18)+1;
until not (((r1-1)*18+r2) in mset);
masiv[r1,r2]:=9;
mset:=mset+[((r1-1)*18+r2)];
end;
for i:=1 to 18 do
for j:=1 to 18 do
begin
if masiv[i,j] <> 9 then begin
co:=0;
if masiv[i,j-1]=9 then co:=co+1;
if masiv[i,j+1]=9 then co:=co+1;
if masiv[i-1,j]=9 then co:=co+1;
if masiv[i+1,j]=9 then co:=co+1;
if masiv[i+1,j+1]=9 then co:=co+1;
if masiv[i+1,j-1]=9 then co:=co+1;
if masiv[i-1,j+1]=9 then co:=co+1;
if masiv[i-1,j-1]=9 then co:=co+1;
masiv[i,j]:=co
end;
end;
setfillstyle(9,1);
bar(0,0,getmaxx,getmaxy);
for i:=1 to 18 do
for j:=1 to 18 do cub(80+i*22,20+j*21);
s:='';
setfillstyle(1,11);
bar(540,340,620,370);
settextstyle(0,0,0);
setcolor(4);
outtextxy(555,350,'ª―ο ™£');
bar(540,390,620,420);
outtextxy(568,400,'—χ');
show_cursor;
repeat
for i:=1 to 18 do
for j:=1 to 18 do
begin
if (omasiv[i,j]=true) and (fmasiv[i,j]=true) then
begin fmasiv[i,j]:=false;col:=col-1;end;
if (smasiv[i,j]=true) and (fmasiv[i,j]=true) then
begin fmasiv[i,j]:=false;col:=col-1;end;
end;
setcolor(0);
setfillstyle(1,0);
bar(570,140,620,170);
str(59-col,s);
setcolor(15);
settextstyle(0,0,2);
outtextxy(580,150,s);
repeat
get_mouse_button_press(button,count,x,y);
until ((button=2) or (button=1));
m:=round((x-90)/22);
n:=round((y-30)/21);
if (x>540) and (y>390) and (x<620) and (y<420) and (button=1) then halt;
if (x>540) and (y>340) and (x<620) and (y<370) and (button=1) then
begin newgame:=true;end;
if (m>0) and (n>0) and (n<19) and (m<19)
and (button=2) then
begin
get_mouse_status(button,x,y);
m:=round((x-90)/22);
n:=round((y-30)/21);
if (m>0) and (n>0) and (n<19) and (m<19)
then
if (not omasiv[m,n]) and (not smasiv[m,n])  then
if not fmasiv[m,n] then
begin
fmasiv[m,n]:=true;
col:=col+1;
hide_cursor;
show_flag(80+m*22,20+n*21);
show_cursor;
end
else  begin
fmasiv[m,n]:=false;
col:=col-1;
hide_cursor;
hide_flag(80+m*22,20+n*21);
show_cursor;
end;
end;
get_mouse_status(button,x,y);
if (m>0) and (n>0) and (n<19) and (m<19)
and (button=1) then
begin
get_mouse_status(button,x,y);
m:=round((x-90)/22);
n:=round((y-30)/21);
if (m>0) and (n>0) and (n<19) and (m<19) and (not fmasiv[m,n]) then begin
if masiv[m,n]=9 then begin
hide_cursor;
show_all;
show_cursor;
repeat
get_mouse_status(button,x,y);
until ((x>540) and (y>340) and (x<620) and (y<370) and (button=1)) or
((x>540) and (y>390) and (x<620) and (y<420) and (button=1));
if (x>540) and (y>390) and (x<620) and (y<420) and (button=1) then halt
else goto 1;
end;
if masiv[m,n]<>0 then begin
hide_cursor;
show(80+m*22,20+n*21,masiv[m,n]);
omasiv[m,n]:=true;
show_cursor;end
else begin
smasiv[m,n]:=true;
show_zero(m,n);end;
end;
end;
repeat
get_mouse_status(button,x,y);
until button=0;
vin:=true;
for i:=1 to 18 do
for j:=1 to 18 do
if (masiv[i,j]=9) then
if (fmasiv[i,j]<>true) then
begin
vin:=false;break
end;
until (vin=true) or (newgame=true);
if newgame=true then goto 1;
if vin=true then begin
hide_cursor;
cleardevice;
setcolor(15);
outtextxy(170,200,'†―σχ £‘‰ρ•χ');
delay(60000);delay(60000);delay(60000);delay(60000);
delay(60000);delay(60000);delay(60000);delay(60000);
end;
end.