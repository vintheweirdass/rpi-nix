
import {promisify} from "node:util"
// please nodejs contributors (not deno) i beg u, PLEASE. UPDATE YOUR API. Its been a long day since u began a war
// with Joyent®, the previous nodejs owner. But until then
// YOU NEVER UPDATED THIS SINGLE PACKAGE???
// If yall updated it, i wouldnt need to import the node:util just for async/await
import {exec as _exec} from "node:child_process"
import {join} from "node:path"
const exec = promisify(_exec)
async function r(){
const p = await exec(`deno run ${join(Deno.cwd(), "build" , Deno.args[0])}`)
const err = p.stderr
// i have no idea, the IDE says that the stderr is only string
// but bcs it is dosent well documented, i might do this
if (err===""||err===null||typeof err==="undefined") return
throw new Error(err)
}
await r()
