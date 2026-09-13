local pc=app.pixelColor
local root=app.params['preview']..'/'
local f=io.open(root..'atlas.json','r');local m=json.decode(f:read('*a'));f:close()
local atlas=Image{fromFile=root..'atlas.png'}
for _,kind in ipairs({'run','roll'}) do
 local sheet=Image(288,192,ColorMode.RGB);sheet:clear(pc.rgba(18,27,43,255))
 for row,v in ipairs({'right','front','left','back'}) do
  for col,index in ipairs(m.clips[kind..'_'..v].indices) do
   local r=m.frames[index+1];sheet:drawImage(Image(atlas,Rectangle(r.x,r.y,48,48)),Point((col-1)*48,(row-1)*48))
  end
 end
 sheet:resize(864,576);sheet:saveAs(root..kind..'-frames.png')
end
