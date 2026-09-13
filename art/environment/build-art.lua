local out=(app.params['project'] or '.')..'/'
local C={void='0d1220',outline='111827',wall='22283f',walllit='333f58',edge='556077',floor='293949',floor2='2c3d4d',grout='21303f',scuff='344555',shadow='182333',cyan='53dce8',ice='b1f4f0',blue='28677e',glow='315666',amber='e8ac60',cream='dfd4a7',metal='536477',light='8293a0',red='954d65',purple='6b567d',green='52766b',brown='805b43',card='ae845b',tape='d1b58c',ink='19202d',white='d7e5e5'}
local function col(c) local h=C[c] or c;return Color{r=tonumber(h:sub(1,2),16),g=tonumber(h:sub(3,4),16),b=tonumber(h:sub(5,6),16),a=255}.rgbaPixel end
local s,im
local function rect(x,y,w,h,c) local p=col(c);for yy=y,y+h-1 do for xx=x,x+w-1 do if xx>=0 and yy>=0 and xx<im.width and yy<im.height then im:drawPixel(xx,yy,p) end end end end
local function box(x,y,w,h,c,b) rect(x,y,w,h,b or 'outline');rect(x+1,y+1,w-2,h-2,c) end
local function layer(name,fn) local l=s:newLayer();l.name=name;im=Image(s.width,s.height,ColorMode.RGB);fn();s:newCel(l,1,im,Point(0,0)) end
local function start(w,h) s=Sprite(w,h,ColorMode.RGB);s.layers[1].name='Transparent base' end
local function save(name) s:saveAs(out..'art/environment/'..name..'.aseprite');local a=Image(s.width,s.height,ColorMode.RGB);a:drawSprite(s,1);a:saveAs(out..'datafiles/environment/'..name..'.png');s:close() end
local glyph={I={'111','010','010','010','111'},C={'111','100','100','100','111'},E={'111','100','110','100','111'},O={'111','101','101','101','111'},P={'110','101','110','100','100'},N={'101','111','111','111','101'},L={'100','100','100','100','111'},A={'010','101','111','101','101'},S={'111','100','111','001','111'},T={'111','010','010','010','010'},B={'110','101','110','101','110'},R={'110','101','110','101','101'}}
local function text(t,x,y,c) for i=1,#t do local g=glyph[t:sub(i,i)];if g then for j,row in ipairs(g) do for k=1,#row do if row:sub(k,k)=='1' then rect(x+(i-1)*4+k-1,y+j-1,1,1,c) end end end end end end
local function product(x,y,k) local cs={'red','blue','green','purple','amber'};box(x,y,5,9,cs[k%5+1]);rect(x+1,y+2,3,2,'cream');rect(x+1,y,3,1,'light');rect(x+2,y+6,1,1,'white') end
start(640,360)
layer('Floor / 16 pixel grid',function()
 rect(16,48,608,266,'void');rect(24,88,592,218,'grout')
 for y=88,305,16 do for x=24,615,16 do rect(x+1,y+1,15,15,((x+y)/16)%2==0 and 'floor' or 'floor2');rect(x+2,y+1,13,1,'scuff');if (x*3+y)%7==0 then rect(x+5,y+9,3,1,'scuff') end end end
end)
layer('Neon light pools / stepped bands',function()
 for i=0,4 do rect(398+i*5,104+i*3,200-i*10,3,i<2 and 'glow' or 'floor2') end
 for i=0,3 do rect(61+i*7,135+i*3,74-i*14,2,i==0 and 'brown' or 'scuff') end
 for y=118,137,5 do for x=411,585,32 do rect(x,y,10,1,'glow') end end
end)
layer('Wall faces / trims',function()
 rect(16,48,608,42,'outline');rect(20,51,600,2,'walllit');rect(24,54,592,34,'wall')
 for x=24,615,48 do box(x,55,47,32,'wall','outline');rect(x+3,58,39,1,'walllit');rect(x+43,59,1,23,'walllit') end
 rect(24,86,592,3,'edge');rect(24,89,592,3,'shadow');rect(16,88,8,219,'wall');rect(18,88,2,219,'walllit');rect(616,88,8,219,'wall');rect(617,88,2,219,'edge');rect(16,306,608,8,'outline');rect(22,306,596,2,'walllit')
 box(30,58,90,19,'void');text('LAST STOP',37,65,'cyan')
 box(184,59,25,25,'metal');rect(187,62,19,4,'cream');rect(187,69,14,2,'red');rect(187,73,16,1,'light');rect(187,76,10,1,'light')
 box(274,62,42,19,'void');for y=66,75,3 do rect(278,y,34,1,'metal') end
 box(336,59,29,24,'purple');text('OPEN',342,63,'cream');rect(342,72,17,2,'amber');rect(348,76,5,2,'cream')
end)
layer('Perimeter details / cartons and bottles',function()
 for i=0,2 do box(30+i*15,287,14,18,'card');rect(36+i*15,289,2,13,'tape') end
 box(79,291,25,13,'blue');for i=0,3 do rect(82+i*5,287,3,12,'metal');rect(83+i*5,286,1,2,'ice');rect(82+i*5,292,3,4,'cyan') end
 for y=123,259,68 do box(603,y,11,34,'metal');for j=0,2 do product(606,y+3+j*10,j) end end
 box(570,289,36,14,'blue');for i=0,4 do rect(573+i*6,284,3,14,'metal');rect(574+i*6,282,1,3,'ice');rect(573+i*6,291,3,4,'cyan') end
end)
save('Last-Stop-Background')
start(48,104)
layer('Ground shadow',function() rect(2,99,46,5,'shadow') end)
layer('Shelf housing / top and feet',function() box(2,0,42,101,'metal');rect(4,2,38,8,'light');rect(7,3,31,5,'wall');rect(8,4,16,2,'red');rect(4,11,38,86,'outline');rect(0,12,3,87,'outline');rect(44,12,3,87,'outline');rect(5,97,36,3,'ink');rect(6,100,7,2,'metal');rect(33,100,7,2,'metal') end)
layer('Stock / labels',function()
 for row=0,4 do for j=0,4 do product(7+j*7,15+row*16,row+j) end
 rect(5,26+row*16,36,3,'metal');rect(6,26+row*16,34,1,'light');rect(12,28+row*16,6,2,'cream');rect(29,28+row*16,5,2,'cream') end
end)
save('Last-Stop-Shelf')
start(96,58)
layer('Counter / ground shadow',function() rect(2,54,94,4,'shadow');box(0,20,93,35,'walllit');box(2,21,89,11,'brown');rect(3,22,86,2,'card');rect(4,34,84,2,'metal');box(5,38,38,14,'wall');box(47,38,40,14,'wall');rect(9,39,27,1,'edge');rect(54,39,27,1,'edge') end)
layer('Till / lamp / countertop stock',function()
 box(23,7,23,22,'ink');box(25,9,19,13,'metal');rect(27,11,14,8,'void');rect(29,14,8,1,'green');rect(20,28,28,3,'light');for x=22,43,4 do rect(x,27,2,1,'white') end
 box(64,10,10,14,'brown');rect(62,8,14,3,'amber');rect(66,11,6,10,'cream');rect(68,24,2,4,'metal');rect(63,28,12,2,'amber');box(6,19,11,12,'metal');rect(8,21,7,5,'cream');product(82,22,1)
end)
save('Last-Stop-Checkout')
start(216,58)
layer('Refrigerator cabinet / shadow',function() rect(0,54,216,4,'shadow');box(0,0,216,54,'metal');rect(2,1,212,3,'blue');rect(3,4,210,2,'cyan');rect(2,50,212,3,'outline') end)
layer('Glass doors / stock / ice',function()
 for d=0,3 do local x=3+d*40;box(x,8,38,41,'outline');rect(x+2,10,32,36,'blue');rect(x+3,11,30,2,'cyan');for row=0,2 do for j=0,3 do product(x+4+j*7,15+row*10,j+row) end;rect(x+2,23+row*10,32,1,'light') end;rect(x+34,25,2,9,'ice');rect(x+4,14,1,28,'glow') end
 box(164,8,49,41,'blue');rect(167,11,43,3,'cyan');rect(169,16,39,27,'glow');text('ICE',181,21,'ice');for j=0,5 do box(171+j*6,34+(j%2)*2,5,7,'cyan','blue');rect(172+j*6,35+(j%2)*2,2,2,'ice') end
end)
save('Last-Stop-Fridges')
start(24,30)
layer('Cardboard carton',function() rect(1,27,23,3,'shadow');box(0,0,22,28,'card');rect(2,2,18,16,'tape');rect(10,1,3,26,'cream');rect(2,20,7,6,'brown');rect(16,21,3,2,'ink');rect(17,19,1,5,'ink');rect(3,3,5,1,'card') end)
save('Last-Stop-Crate')
-- A reusable four-variant tile strip, also supplied as editable source.
start(64,16)
layer('Floor variants',function() for k=0,3 do rect(k*16,0,16,16,'grout');rect(k*16+1,1,15,15,k%2==0 and 'floor' or 'floor2');rect(k*16+2,1,13,1,'scuff');if k>1 then rect(k*16+5,9,3,1,'scuff') end end end)
save('Last-Stop-Floor-Tiles')
local f=io.open(out..'art/environment/build-result.txt','w');f:write('6 editable Aseprite sources and 6 PNG exports created.\n');f:close()
