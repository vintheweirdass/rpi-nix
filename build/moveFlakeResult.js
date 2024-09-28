// allow-read allow-write
import {promisify} from "node:util"
// please nodejs contributors (not deno) i beg u, PLEASE. UPDATE YOUR API. Its been a long day since u began a war
// with Joyent®, the previous nodejs owner. But until then
// YOU NEVER UPDATED THIS SINGLE PACKAGE???
// If yall updated it, i wouldnt need to import the node:util just for async/await
import {exec as _exec} from "node:child_process"
const exec = promisify(_exec)

import {copyFile, readlink } from "node:fs/promises";
import {join, isAbsolute} from "node:path";
function alwaysAbs(pth:string, cwd:string){
    return isAbsolute(pth)?pth:join(pth, cwd)
}
const cwd = Deno.cwd()
if (Deno.args.length!==1) throw new Error("Arg must be only ONE, not two or three... just ONE");
const name = Deno.args[0]
const sympth = alwaysAbs(await readlink(join(cwd, "result")), cwd)
await copyFile(sympth, join(cwd, `${name}-releasedate: ${Temporal.Now.plainDateTimeISO().toZonedDateTime("Asia/Jakarta").toLocaleString("en-US",{
      dateStyle: 'medium',
      timeStyle: 'short'
    })}.img`))
// clean nix-store, FUCK
await exec('sudo nix-store --gc --print-roots')  
await exec('rm -rf /tmp/*')
