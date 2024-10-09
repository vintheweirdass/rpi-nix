// allow-read allow-write
import {promisify} from "node:util"
// please nodejs contributors (not deno) i beg u, PLEASE. UPDATE YOUR API. Its been a long day since u began a war
// with Joyent®, the previous nodejs owner. But until then
// YOU NEVER UPDATED THIS SINGLE PACKAGE???
// If yall updated it, i wouldnt need to import the node:util just for async/await
import {exec as _exec} from "node:child_process"
const exec = promisify(_exec)

import {copyFile, readlink,rm } from "node:fs/promises";
import {join} from "node:path";

const cwd = Deno.cwd()
const version = Deno.args[0]
const name = Deno.args[1]
const sympth = await readlink(join(cwd, "result"))
await copyFile(sympth, join(cwd,"dist", version, `${version}-${name}.img`))
await rm(join(cwd, "result"))
