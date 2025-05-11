// ===== bejana_interprener.js =====
class BejanaInterprener {
    constructor() {
        this.data = {};
        this.inBlock = false;
        this.blockLines = [];
        this.outputFn = outputFn || function(msg) { console.log(msg); };
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
        if (/^isi (\w+)\s+"?(.*?)"?$/.test(baris)) {
            const [_, kunci, nilai] = baris.match(/^isi (\W+)\s+"?(.*?)"?$/);
            this.data[kunci] = isNaN(parseInt(nilai)) ? nilai : parseInt(nilai);
        } else if (/^cetak "(.*?)"$/.test(baris)) {
            const teks = baris.match(/^cetak "(.*?)"$/)[1];
            const hasil = baris.replace(/{{(.*?)}}/g, (_, key) => {
                return this.data[key.trim()] || '';
            });
            this.outputFn(hasil);
        } else {
            this.outputFn(`Perintah tidak dikenali: ${baris}`)
        }
    }
}



// ===== Modules =====
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
    isiDariPengguna(kunci) {
        const input = prompt(`${kunci}: `);
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
    _stopLoop: false,

    fungsiMap: {},
    data: new Environment(),

    fungsi(nama, ...parameter) {
        this.fungsiMap[nama] = { parameter: parameter };
    },

    panggil(nama, ...args) {
        if (this.fungsiMap[nama]) {
            const context = this.fungsiMap[nama];
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

        if (kondisi(nilai)) {
            block();
        }
    },

    selainJika(kunci, kondisi, block) {
        this.elseBlock = block;
    },

    berhentiJika(kondisi) {
        if (typeof kondisi === 'function' && kondisi()) {
            this._stopLoop = true;
        }
    },

    selama(kondisi, aksi) {
        this._stopLoop = false;
        while (kondisi()) {
            aksi();
            if (this._stopLoop) break;
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

function buatWadah() {
    const wadah = new Wadah();

    return new Proxy(wadah, {
        get(target, prop) {
            if (typeof target[prop] !== "undefiend") {
                return target[prop];
            } else {
                return (...args) => target.methodMissing(prop, ...args);
            }
        }
    });
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
            Object.entries(kriteria).every(([key, value]) => rekam[key] === value)
        );
    }
    semua() {
        return this.data;
    }
}


// Modul Penyimpanan File
class PenyimpananFile {
    constructor(namaKunci) {
        this.namaKunci = namaKunci;
    }
    simpan(data) {
        localStorage.setItem(this.namaKunci, JSON.stringify(data));
    }
    muat() {
        const isi = localStorage.getItem(this.namaKunci);
        return isi ? JSON.parse(isi) : [];
        }
    hapus() {
        localStorage.removeItem(this.namaKunci);
    }
    }
}



// ===== Plugins =====
// Modul Analitik
const AnalitikModul = {
    deviasiStandar(data) {
        const mean = data.reduce((a, b) => a + b, 0) / data.length;
        const variance = data.reduce((sum, val) => sum + Math.pow(val - mean,  2), 0) / data.length;
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
    run(context) {
        console.log("Visualisasi Struktur Data Bejana:")
        this.printStructure(context["data"], 0)
    }
    printStructure(obj, indent = 0) {
        const prefix = "".repeat(indent);
        if (Array.isArray(obj)) {
            obj.forEach((item, index) => {
                console.log(`${prefix}- [${index}]:`);
                this.printStructure(item, indent + 2);
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

// Modul Navigator
class Navigator {
    constructor(context = {}) {
        this.langkah = {};
        this.current = null;
        this.context = context;
    }

    tambah(nama, block) {
       this.langkah[nama] = blok;
    }

    mulaiDari(nama) {
        this.current = nama;
        while(this.current && typeof this.langkah[this.current] === 'function') {
            const blok = this.langkah[this.current];
            this.current = blok.call(this.context);
        }
    }
}



const modul = {
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
    const args = argumenStr.split(',').map(a => {
        try {
            JSON.parse(a.trim()));
        } catch (e) {
            return a.trim();
        }
    });
            
    const mod = modul[namaModul];
    if (!mod || typeof mod[namaFungsi] !== 'function') {
        throw new Error(`Fungsi ${namaModul}.${namaFungsi} tidak ditemukan.`)
    }

    return mod[namaFungsi](...args);
}



// ===== Menjalankan bejana, jalankan_bejana.js =====
const output = document.getElementById("output");
const interpreter = new BejanaInterpreter(msg => {
  output.textContent += msg + "\n";
});

function jalankanSkrip() {
    output.textContent = "";
    const kode = document.getElementById("kode").value;
    const baris = kode.split("\n");
    baris.forEach(line => interpreter.jalankan(line.trim()));
}

function bersihkan() {
    output.textContent = "";
}
window.BejanaInterpreter = BejanaInterpreter;
window.interpret = interpret;
