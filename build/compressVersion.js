// allow-read allow-write
import {promisify} from "node:util"
// please nodejs contributors (not deno) i beg u, PLEASE. UPDATE YOUR API. Its been a long day since u began a war
// with Joyent®, the previous nodejs owner. But until then
// YOU NEVER UPDATED THIS SINGLE PACKAGE???
// If yall updated it, i wouldnt need to import the node:util just for async/await
import {exec as _exec} from "node:child_process"
const exec = promisify(_exec)
import {join} from "node:path";
import fs from "node:fs/promises";
const version = Deno.args[0]
Deno.chdir(join(Deno.cwd(), "dist", version))
const cwd = Deno.cwd()
const dir = await fs.readdir(cwd, {withFileTypes:true})
for (const each of dir) {
    if ((each.name.endsWith(".img") && each.isFile()) === false) continue
    const pth = join(cwd, each.name)
    await exec(`zstd ${pth}`)
    await exec(`sudo rm -f ${pth}`)
}
