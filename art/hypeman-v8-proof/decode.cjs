// Encode the unmodified GameMaker framebuffer bytes as PNG for visual review.
const fs=require('fs'),zlib=require('zlib'),path=require('path');
const root=path.resolve(__dirname,'../../work/hypeman-v8'),out=path.resolve(__dirname,'review/game-renders');fs.mkdirSync(out,{recursive:true});
const table=new Uint32Array(256);for(let n=0;n<256;n++){let c=n;for(let k=0;k<8;k++)c=c&1?0xedb88320^(c>>>1):c>>>1;table[n]=c;}
function crc(b){let c=0xffffffff;for(const v of b)c=table[(c^v)&255]^(c>>>8);return (c^0xffffffff)>>>0;}
function chunk(type,data){const t=Buffer.from(type);const len=Buffer.alloc(4);len.writeUInt32BE(data.length);const hash=Buffer.alloc(4);hash.writeUInt32BE(crc(Buffer.concat([t,data])));return Buffer.concat([len,t,data,hash]);}
for(const f of fs.readdirSync(root).filter(f=>/^capture-.*\.log$/.test(f))){
 const text=fs.readFileSync(path.join(root,f),'utf8');if(/FATAL|SQ_FAIL|ERROR!!!/.test(text))throw Error(f+' runner failure');
 const dimensions=[...text.matchAll(/SQ_FRAME_SIZE (\d+) (\d+)/g)].at(-1),encoded=[...text.matchAll(/SQ_FRAMEBUFFER ([A-Za-z0-9+/=]+)/g)].at(-1);if(!dimensions||!encoded){console.log('Pending '+f);continue;}
 const w=+dimensions[1],h=+dimensions[2],pixels=Buffer.from(encoded[1],'base64');if(pixels.length!==w*h*4)throw Error('Framebuffer length');
 const scan=Buffer.alloc(h*(w*4+1));for(let y=0;y<h;y++)pixels.copy(scan,y*(w*4+1)+1,y*w*4,(y+1)*w*4);
 const hdr=Buffer.alloc(13);hdr.writeUInt32BE(w);hdr.writeUInt32BE(h,4);hdr[8]=8;hdr[9]=6;
 const png=Buffer.concat([Buffer.from([137,80,78,71,13,10,26,10]),chunk('IHDR',hdr),chunk('IDAT',zlib.deflateSync(scan)),chunk('IEND',Buffer.alloc(0))]);
 fs.writeFileSync(path.join(out,f.replace(/^capture-/,'').replace(/\.log$/,'.png')),png);
 console.log(f+': '+w+'x'+h+' first pixel '+Array.from(pixels.subarray(0,4)).join(','));
}
