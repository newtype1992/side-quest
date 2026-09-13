local root=app.params['project']..'/'
local out=root..'art/environment-v2/'
local runtime=root..'datafiles/environment-v2/'
local function load(name)
 local s=app.open(out..name..'.png');s:resize(1280,720)
 local im=Image(1280,720,ColorMode.RGB);im:drawSprite(s,1);s:close();return im
end
local full=load('clean-room');local plate=load('floor-plate')
local master=Sprite(1280,720,ColorMode.RGB);master.layers[1].name='Transparent base'
local function add(name,image,point)
 local l=master:newLayer();l.name=name;master:newCel(l,1,image,point or Point(0,0));return l
end
-- UI is supplied by the game. Preserve only the environment region in the art.
local bg=Image(1280,720,ColorMode.RGB)
bg:drawImage(Image(plate,Rectangle(24,92,1232,540)),Point(24,92))
local lower=Image(1280,720,ColorMode.RGB)
lower:drawImage(Image(bg,Rectangle(0,216,1280,504)),Point(0,216))
add('Room floor / light reflections / perimeter detail',lower)
local north=Image(1280,216,ColorMode.RGB);north:drawImage(bg)
add('North wall / checkout / lighting / stocked fridges',north)
bg:saveAs(runtime..'Room.png')
local pieces={
 {name='Shelf-Left',x=398,y=288,w=86,h=228},
 {name='Shelf-Right',x=762,y=288,w=90,h=228},
 {name='Crate',x=576,y=364,w=58,h=72}
}
for _,p in ipairs(pieces) do
 local im=Image(full,Rectangle(p.x,p.y,p.w,p.h))
 im:saveAs(runtime..p.name..'.png')
 add(p.name..' / movable cover',im,Point(p.x,p.y))
 local s=Sprite(p.w,p.h,ColorMode.RGB);s.layers[1].name=p.name..' retained approved pixels';s:newCel(s.layers[1],1,im);s:saveAs(out..p.name..'.aseprite');s:close()
end
master:saveAs(out..'Last-Stop-Room-v2.aseprite')
local check=Image(1280,720,ColorMode.RGB);check:drawSprite(master,1);check:saveAs(out..'assembly-preview.png')
master:close()
local f=io.open(out..'export-result.txt','w');f:write('1280x720 assembled room; four runtime PNGs; four editable Aseprite sources.\n');f:close()
