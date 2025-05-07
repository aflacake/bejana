// ===== bejana_interprener.js =====
class BejanaInterprener {
    constructor() {
        this.data = {};
        this.inBlock = false;
        this.blockLines = [];
    }
    jalankan(baris) {
        if (/^mulai$/.test(baris)) {
            this.inBlock = true;
            this.blockLines = [];
        } else if (/^selesai$/.test(baris)) {
            this.inBlock = false;
            this.blockLines.forEach(line => this.jalankan(line));
        } else {
            if (this.inBlock) {
                this.blockLines.push(baris);
            } else {
                this.proses(baris);
            }
        }
    }
    proses(baris) {
        if (/^isi (\W+)\s+"?(.*?)"?$/.test(baris)) {
            const [_, kunci, nilai] = baris.match(/^isi (\W+)\s+"?(.*?)"?$/);
            this.data[kunci] = isNaN(parseInt(nilai)) ? nilai : parseInt(nilai);
        } else if (/^cetak "(.*?)"$/.test(baris)) {
            const teks = baris.replace(/{{(.*?)}}/g, (_, key) => {
                return this.data[key.trim()] || '';
            });
            console.log(teks);
        } else {
            console.log(`Perintah tidak dikenali: ${baris}`)
        }
    }
}

module.exports = BejanaInterpreter;



// ===== Modules =====
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


// Modul Output
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


// Modul Basis Data
class BasisData {
    constructor() {
        this.data = [];
    }
    tambah(rekam) {
        this.data.push(rekam);
    }
    cari(kriteria) {
        return this.data.filter(rekam =>
            Object.entries(kriteria).every([key, value]) => rekam[key] === value)
        );
    }
    semua() {
        return this.data;
    }
}


// Modul Penyimpanan File
const fs = require('fs');

class PenyimpananFile {
    contructor(namaFile) {
        this.namaFile = namaFile;
    }
    simpan(data) {
        fs.writeFileSync(this.namaFile, JSON.stringify(data, null, 2), 'utf8');
    }
    muat() {
        if (fs.existsSync(this.namaFile)) {
            const content = fs.readFileSync(this.namaFile, 'utf8');
            return JSON.parse(content);
        } else {
            return[];
        }
    }
}



// ===== Plugins =====
// Modul Analitik
const AnalitikModul = {
    deviasiStandar(data) {
        const mean = data.reduce((a, b) => a + b, 0) / data.length;
        const variance = data.reduce((sum, val) sum + Math.pow(val - mean,  2), 0) / data.length;
        return Math.sqrt(variance);
    }
};

// Modul Proses Data
const ProsesDataModul = {
    rataRata(data) {
        const sum = data.reduce((a, b) => a + b, 0)
        return sum / data.length;
    },
    median(data) {
        const sorted = [...data].sort((a, b) => a - b);
        const mid = Math.floor(sorted.length / 2);

        if (sorted.length %2 === 0) {
            return (sorted[mid - 1] + sorted[mid]) / 2;
        } else {
            return sorted[mid];
        }
    }
}

// Modul Visualisasi
const VisualisasiModul = {
    run: function(context) {
        console.log("Visualisasi Struktur Data Bejana:")
        this.printStructure(context["data"], 0)
    }
    printStructure: function(obj, indent) {
        const prefix = "".repeat(indent);
        if (Array.isArray(obj)) {
            obj.forEach((item, index) => {
                console.log(`${prefix}- [${index}]:`);
                this.printStucture(item, indent + 2);
            });
        } else if (obj !== null && typeof obj === 'object') {
            for (const [key, value] of Object.entries(obj)) {
                console.log(`${prefix}- ${key}:`);
                this.printStructure(value, indent + 2);
            }
        } else {
            console.log(`${prefix}- ${obj}`);
        }
    }
}



const modul = {
  aritmatika,
  logika,
  FungsiInput,
  FungsiOutput,
  FungsiLogika,
  Wadah,
  Environment,
  BasisData,
  PenyimpananFile,
  AnalitikModul,
  ProsesDataModul,
  VisualisasiModul
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



// ===== Menjalankan bejana, jalankan_bejana.js =====
const fs = require('fs');
const readlineSync = require('readline-sync');
const BejanaInterprener = require('./bejana_interprener');
const filename = process.argv[2] || 'script.bj'

if (fs.existsSync(filename)) {
    const lines = fs.readFileSync(filename, 'utf-8').split('\n');

    lines.forEach((line, index) => {
        line = line.trim();
        if (line === '' || line.startsWith('#')) {
            return;
        }
        try {
            const interprener = new BejanaInterpreter();
            interprener.jalankan(line);
        } catch (e) {
            console.error(`Error di baris ${index + 1}: ${line}`);
            console.error(`Pesan: ${e.message}`)
        }
    });
} else {
    console.log(`File ${filename} tidak ditemukan`);
}
