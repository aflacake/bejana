// Modul
const aritmatika = {
    tambah: (a, b) => a + b,
    kurang: (a, b) => a - b,
    kali: (a, b) => a * b,
    bagi: (a, b) => a / b
};


const logika = {
    dan: (a, b) => a && b,
    atau: (a, b) => a || b,
    tidak: (a) => !a
}


// Modul Environment
class Environment {
    constructor() {
        this.storage = {};
    }

    set(kunci, nilai) {
        this.storage[kunci] = nilai;
    }

    get(kunci) {
        return this.storage[kunci];
    }

    exist(kunci) {
        return Object.prototype.hasOwnProperty.call(this.storage, kunci);
    }

    all() {
        return { ...this.storage };
    }

    delete(kunci) {
        delete this.storage[kunci];
    }

    clear() {
        this.storage = {};
    }
}


// Modul Input
const FungsiInput = {
    isiDariPengguna(kunci, promptFn) {
        const input = promptFn(`${kunci}: `);
        let parsedInput = input;

        if (/^\d+$/.test(input)) {
            parsedInput = parseInt(input, 10);
        }
        return { [kunci]: parsedInput };
    },
    ambil(kunci, environment) {
        return environment.get(kunci);
    }
};


//Modul Output
const FungsiOutput = {
    cetak(teks, data) {
        console.log(teks.replace(/{{(.*?)}}/g, (match, key) => {
            return data[key.trim()] ? data[key.trim()] : '';
        }));
    }
};


// Modul Logika Tambahan
const FungsiLogika = {
    fungsi: {},
    data: new Environment(),

    fungsi(nama, ...parameter) {
        this.fungsi[nama] = { parameter: parameter };
    },

    panggil(nama, ...args) {
        if (this.fungsi[nama]) {
            const context = this.fungsi[nama];
            const params = context.parameters;
            let result = null;

            const oldData = { ...this.data.all() };

            params.forEach((param, index) => {
                this.data.set(param, args[index]);
            });
            result = this.data;
            this.data = oldData;
            return result;
        } else {
            console.log(`Fungsi '${nama}' tidak ditemukan`);
        }
    },

    jika(kunci, kondisi, block) {
        const nilai = this.data.get(kunci);
        const hasil = kondisi(nilai);

        if (hasil) {
            block();
        } else if (this.lastJika === false && this.elseBlock) {
            this.elseBlock();
        }
    },
    selainJika(kunci, kondisi, block) {
        this.elseBlock = block;
    },
    selama(kondisi, aksi) {
        while (kondisi()) {
            aksi();
        }
    }
};


class Wadah {
    constructor() {
        this.data = {};
        this.actions = [];
    }

    methodMissing(name, ...args) {
        if (args.length > 0) {
            this.data[name] = args[0];
        } else {
            console.log(`Method ${name} dipanggil tanpa parameter`);
        }
        return this;
    }
    jalankan() {
        this.actions.forEach(actions => {
            console.log(`Menjalankan ${action.name}`);
            action.block();
        });
    }
    tampilan(isi = null) {
        console.log(isi || JSON.stringify(this.data, null, 2));
    }
}

const modul = {
  aritmatika: {
    tambah: (a, b) => a + b,
    kurang: (a, b) => a - b,
    kali: (a, b) => a * b,
    bagi: (a, b) => a / b
  },
  logika,
  FungsiInput,
  FungsiOutput,
  FungsiLogika,
  Wadah,
  Environment
};

function interpret(input) {
    const match = input.match(/^(\w+)\.(\w+)\(([^)]*)\)$/);
    if (!match) throw new Error("Format salah. Gunakan format modul.fungsi(arg1, arg2)");

    const [, namaModul, namaFungsi, argumenStr] = match;
    const args = argumenStr
        .split(',')
        .map(a => JSON.parse(a.trim()));

    const mod = modul[namaModul];
    if (!mod || typeof mod[namaFungsi] !== 'function') {
        throw new Error(`Fungsi ${namaModul}.${namaFungsi} tidak ditemukan.`)
    }

    return mod[namaFungsi](...args);
}
