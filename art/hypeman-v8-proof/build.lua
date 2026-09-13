local root=app.params['project']..'/'
local src=root..'art/hypeman-v8-proof/';local out=root..'datafiles/hypeman-v8-proof/'
local preview=app.params['preview']..'/'
local pc=app.pixelColor
local colors={'07080c','132039','23395f','36577b','5b351f','935328','bf762f','dc994e','222b34','47545e','00b8e0','45d6ed','e9ebdf','9eacb7','ffffff','67492f'}
local pal={};local palette=Palette(#colors+1);palette:setColor(0,Color{r=0,g=0,b=0,a=0})
for i,h in ipairs(colors) do local c=Color{r=tonumber(h:sub(1,2),16),g=tonumber(h:sub(3,4),16),b=tonumber(h:sub(5,6),16),a=255};pal[i]={c.red,c.green,c.blue,c.rgbaPixel};palette:setColor(i,c) end
local function nearest(p) local r,g,b=pc.rgbaR(p),pc.rgbaG(p),pc.rgbaB(p);local score,hit=1e9,1;for i,c in ipairs(pal) do local d=(r-c[1])^2+(g-c[2])^2+(b-c[3])^2;if d<score then score=d;hit=i end end;return pal[hit][4] end
local function blank()return Image(48,48,ColorMode.RGB) end
local function rect(im,x,y,w,h,c)for yy=y,y+h-1 do for xx=x,x+w-1 do if xx>=0 and xx<im.width and yy>=0 and yy<im.height then im:drawPixel(xx,yy,pal[c][4]) end end end end
local function extract(im,x,y,w,h,navy)
 local b={x=w,y=h,r=-1,b=-1};local crop=Image(w,h,ColorMode.RGB)
 for yy=0,h-1 do for xx=0,w-1 do
  local p=im:getPixel(x+xx,y+yy);local r,g,bl=pc.rgbaR(p),pc.rgbaG(p),pc.rgbaB(p)
  local bg=(r>100 and bl>100 and g<110 and r>g*1.5 and bl>g*1.5)
  if navy then bg=(r>4 and r<42 and g>r and g<62 and bl>g and bl<90) end
  if not bg then crop:drawPixel(xx,yy,p);b.x=math.min(b.x,xx);b.y=math.min(b.y,yy);b.r=math.max(b.r,xx);b.b=math.max(b.b,yy) end
 end end
 assert(b.r>=b.x,'Empty source cell');return Image(crop,Rectangle(b.x,b.y,b.r-b.x+1,b.b-b.y+1))
end
local function cell(im,col,row,cols,rows)
 local x=math.floor(col*im.width/cols);local y=math.floor(row*im.height/rows)
 return extract(im,x,y,math.floor((col+1)*im.width/cols)-x,math.floor((row+1)*im.height/rows)-y,false)
end
local function native(im,height,bob)
 local w=math.max(1,math.floor(im.width*height/im.height+.5));local n=Image(w,height,ColorMode.RGB)
 -- Nearest source sampling and explicit binary alpha/palette; no resampling fringe.
 for y=0,height-1 do for x=0,w-1 do local p=im:getPixel(math.min(im.width-1,math.floor((x+.5)*im.width/w)),math.min(im.height-1,math.floor((y+.5)*im.height/height)));if pc.rgbaA(p)>0 then n:drawPixel(x,y,nearest(p)) end end end
 local frame=blank();frame:drawImage(n,Point(24-math.floor(w/2),44-height-(bob or 0)));return frame
end
local function mirror(im)local n=blank();for it in im:pixels() do n:drawPixel(47-it.x,it.y,it()) end;return n end
local model=Image{fromFile=src..'model-source.png'};local run=Image{fromFile=src..'run-source.png'};local roll=Image{fromFile=src..'roll-source.png'}
local base={front=native(cell(model,0,0,3,1),28),right=native(cell(model,1,0,3,1),28),back=native(cell(model,2,0,3,1),28)};base.left=mirror(base.right)
local frames={};local clips={};local weapons={};local layers={}
local function addclip(name,ims,times,muzzles)
 local indices={};local total=0
 for i,im in ipairs(ims) do local n=#frames;frames[n+1]={im=im,time=times[i],name=name..'_'..i};indices[i]=n;total=total+times[i] end
 clips[name]={indices=indices,durations=times,total=total};return indices
end
local views={'right','front','left','back'}
for _,v in ipairs(views) do
 local idle={};for i=1,4 do idle[i]=blank();idle[i]:drawImage(base[v]);if i==2 or i==4 then
  local upper=Image(base[v],Rectangle(0,0,48,39));idle[i]=blank();idle[i]:drawImage(upper,Point(0,1));idle[i]:drawImage(Image(base[v],Rectangle(0,39,48,9)),Point(0,39))
 end end
 addclip('idle_'..v,idle,{300,100,300,100})
 local row=v=='front' and 1 or (v=='back' and 2 or 0);local ims={}
 for i=1,6 do ims[i]=native(cell(run,i-1,row,6,3),28,(i==3 or i==6) and 1 or 0);if v=='left' then ims[i]=mirror(ims[i]) end end
 addclip('run_'..v,ims,{80,80,80,80,80,80})
 ims={};local stand=cell(roll,5,row,6,3).height
 for i=1,6 do local raw=cell(roll,i-1,row,6,3);local h=math.floor(raw.height*28/stand+.5);ims[i]=native(raw,h,(i==2 or i==3 or i==4) and 2 or 0);if v=='left' then ims[i]=mirror(ims[i]) end end
 -- Recover to exact approved idle model instead of introducing a new silhouette.
 ims[6]=base[v];addclip('roll_'..v,ims,{50,60,90,90,60,30})
end
-- Simple independent pistol/hand layer, drawn on the same native grid in eight directions.
local gun=Image(11,8,ColorMode.RGB)
rect(gun,0,1,10,5,1);rect(gun,1,2,8,2,10);rect(gun,1,1,8,1,14);rect(gun,1,5,3,3,1);rect(gun,2,5,2,2,7)
local dirs={'e','ne','n','nw','w','sw','s','se'}
for di,d in ipairs(dirs) do
 local a=(di-1)*math.pi/4;local co,si=math.cos(a),math.sin(a);local ims={};local mus={}
 for i=1,3 do
  local recoil=({2,1,0})[i];local x=24+math.floor(co*(9-recoil)+.5);local y=34-math.floor(si*(5-recoil)+.5);local im=blank()
  -- Foreshorten vertical aim and offset the rear grip beside the head.
  local reach=1
  if d=='s' then x=26;y=35-recoil;reach=.6 end
  if d=='n' then x=32;y=32+recoil;reach=.75 end
  for it in gun:pixels() do if pc.rgbaA(it())>0 then local u,v=(it.x-2)*reach,it.y-4;local xx=math.floor(x+u*co+v*si+.5);local yy=math.floor(y-u*si+v*co+.5);im:drawPixel(xx,yy,it()) end end
  local mx=math.floor(x+8*reach*co-2*si+.5);local my=math.floor(y-8*reach*si-2*co+.5)
  if i==1 then rect(im,mx-1,my-1,3,3,8);rect(im,mx,my,1,1,15) end
  ims[i]=im;mus[i]={x=mx,y=my}
 end
 weapons[d]={indices=addclip('fire_'..d,ims,{30,50,90}),muzzle=mus,rear=(d=='n' or d=='ne' or d=='nw')}
end
-- Compact concept key-pose death hold prevents a size/identity jump in the proof.
local board=Image{fromFile=src..'approved-model.png'}
local ds={extract(board,250,752,286,212,true),extract(board,635,772,237,190,true),extract(board,1020,829,389,132,true)}
local death={native(ds[1],26),native(ds[2],23),native(ds[3],11)}
for _,v in ipairs(views) do local ims={};for i=1,3 do ims[i]=v=='left' and mirror(death[i]) or death[i] end;addclip('death_'..v,ims,{140,260,300}) end
local s=Sprite(48,48,ColorMode.RGB);s:setPalette(palette);s.layers[1].name='Native body / pose';local wl=s:newLayer();wl.name='Independent pistol / recoil'
local atlas=Image(768,math.ceil(#frames/16)*48,ColorMode.RGB);local meta={version='v8-proof',origin={x=24,y=44},frameSize=48,bodyHeight=28,clips=clips,weapons=weapons,frames={},palette=colors}
local allowed={};for _,p in ipairs(pal) do allowed[p[4]]=true end
local pixels=0
for i,f in ipairs(frames) do
 if i>1 then s:newEmptyFrame() end
 s.frames[i].duration=f.time/1000;s:newCel(f.name:sub(1,5)=='fire_' and wl or s.layers[1],i,f.im,Point(0,0))
 local x=(i-1)%16*48;local y=math.floor((i-1)/16)*48;atlas:drawImage(f.im,Point(x,y));meta.frames[i]={x=x,y=y}
 for it in f.im:pixels() do if pc.rgbaA(it())>0 then assert(pc.rgbaA(it())==255 and allowed[it()],'Unclean alpha/palette');assert(it.x>0 and it.x<47 and it.y>0 and it.y<47,'Clipped frame');pixels=pixels+1 end end
end
for name,c in pairs(clips) do local t=s:newTag(c.indices[1]+1,c.indices[#c.indices]+1);t.name=name end
s:saveAs(src..'Hype-Man-v8-Proof.aseprite');atlas:saveAs(out..'Hype-Man-Proof.png');s:close()
local f=io.open(out..'Hype-Man-Proof.json','w');f:write(json.encode(meta));f:close()
local sheet=Image(192,48,ColorMode.RGB);sheet:clear(pc.rgba(18,27,43,255));for i,v in ipairs(views) do sheet:drawImage(base[v],Point((i-1)*48,0)) end;sheet:saveAs(preview..'native-model.png');sheet:resize(1152,288);sheet:saveAs(preview..'model-6x.png')
local function gif(name,kind,count,times,armed)
 local a=Sprite(208,52,ColorMode.RGB)
 for i=1,count do if i>1 then a:newEmptyFrame() end
  local im=Image(208,52,ColorMode.RGB);im:clear(pc.rgba(18,27,43,255))
  for slot,v in ipairs(views) do
   local c=clips[kind..'_'..v];local body=frames[c.indices[i]+1].im;local dx=(slot-1)*52+2
   if armed then local dir=({'e','s','w','n'})[slot];local gun=frames[weapons[dir].indices[3]+1].im;if weapons[dir].rear then im:drawImage(gun,Point(dx,2)) end;im:drawImage(body,Point(dx,2));if not weapons[dir].rear then im:drawImage(gun,Point(dx,2)) end
   else im:drawImage(body,Point(dx,2)) end
  end
  a:newCel(a.layers[1],i,im);a.frames[i].duration=times[i]/1000
 end
 a:saveAs(preview..name..'.aseprite');app.command.SpriteSize{ui=false,width=832,height=208,method='nearest-neighbor'};app.command.SaveFileAs{ui=false,filename=preview..name..'.gif'};a:close()
end
gif('Idle','idle',4,{300,100,300,100},true);gif('Run','run',6,{80,80,80,80,80,80},true);gif('Dodge','roll',6,{50,60,90,90,60,30},false)
local fire=Sprite(208,52,ColorMode.RGB)
for i,idx in ipairs({3,1,2,3}) do
 if i>1 then fire:newEmptyFrame() end
 local im=Image(208,52,ColorMode.RGB);im:clear(pc.rgba(18,27,43,255))
 for slot,v in ipairs(views) do
  local dir=({'e','s','w','n'})[slot];local w=weapons[dir];local g=frames[w.indices[idx]+1].im;local pos=Point((slot-1)*52+2,2)
  if w.rear then im:drawImage(g,pos) end;im:drawImage(base[v],pos);if not w.rear then im:drawImage(g,pos) end
 end
 fire:newCel(fire.layers[1],i,im);fire.frames[i].duration=({400,30,50,220})[i]/1000
end
fire:saveAs(preview..'Fire.aseprite');app.command.SpriteSize{ui=false,width=832,height=208,method='nearest-neighbor'};app.command.SaveFileAs{ui=false,filename=preview..'Fire.gif'};fire:close()
local clipCount=0;for _ in pairs(clips) do clipCount=clipCount+1 end
f=io.open(preview..'asset-validation.json','w');f:write(json.encode({frames=#frames,clips=clipCount,colors=#colors,binaryAlpha=true,clearMargins=true,visiblePixels=pixels,bodyHeight=28,drawCanvas=48}));f:close()
