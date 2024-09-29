import {join} from "node:path";
import {mkdir} from "node:fs/promises";
await mkdir(join(Deno.cwd(), "dist", Deno.args[0]))
