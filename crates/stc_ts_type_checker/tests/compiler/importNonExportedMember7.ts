// @module: es2015
// @esModuleInterop: true

// @Filename: a.ts
class Foo {}
export = Foo;

// @Filename: b.ts
import { Foo } from './a';