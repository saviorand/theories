function toPrologAtom(str) {
    return str.replace(/ /g, '_').toLowerCase();
}

const currentFolder = dv.current().file.folder;
const pages = dv.pages().filter(p => p.file && p.file.folder.startsWith(currentFolder));
let prologStatements = '';
const fileMap = {};
const fileMapAll = {};
let triples = [];

pages.forEach(page => {
    if (page.file && page.file.path) {
        const path = page.file.path;
        const fileName = toPrologAtom(page.file.name);
        fileMap[path] = fileName;
    }
});

dv.pages().forEach(page => {
    if (page.file && page.file.path) {
        const path = page.file.path;
        const fileName = toPrologAtom(page.file.name);
        fileMapAll[path] = fileName;
    }
});

pages.forEach(page => {
    if (!page.file || !page.file.path) return;
    const path = page.file.path;
    const fileName = toPrologAtom(page.file.name);
    const folderName = toPrologAtom(page.file.folder.split('/').pop());
    const outgoingLinks = page.file.outlinks ? [...new Set(page.file.outlinks.values.map(l => l.path))] : [];
    const processedLinks = {};

    // Process named links and other relationships
    Object.entries(page).forEach(([key, val]) => {
        if (Array.isArray(val)) {
            val.forEach(item => {
                if (item && item.path) {
                    const toFileName = fileMapAll[item.path];
                    if (fileName !== toFileName) {
                        triples.push({ from: fileName, to: toFileName, rel: toPrologAtom(key) });
                        processedLinks[item.path] = true;
                    }
                }
            });
        } else if (val && val.path) {
            const toFileName = fileMapAll[val.path];
            if (fileName !== toFileName) {
                triples.push({ from: fileName, to: toFileName, rel: toPrologAtom(key) });
                processedLinks[val.path] = true;
            }
        }
    });

    // Process parent relationships
    outgoingLinks.forEach(linkPath => {
        const toPage = dv.page(linkPath);
        if (toPage && toPage.file) {
            const toFileName = fileMapAll[toPage.file.path];
            if (toPage.file.folder === page.file.folder || toPage.file.folder.startsWith(page.file.folder + '/')) {
                triples.push({ from: fileName, to: toFileName, rel: 'parent' });
            }
        }
    });

    // Process remaining unnamed links
    outgoingLinks.forEach(linkPath => {
        if (!processedLinks[linkPath]) {
            const toFileName = fileMapAll[linkPath];
            if (fileName !== toFileName) {
                triples.push({ from: fileName, to: toFileName, rel: 'linked' });
            }
        }
    });
});

// Remove duplicate triples
const uniqueTriples = Array.from(new Set(triples.map(JSON.stringify))).map(JSON.parse);

// Generate atoms for each node
const nodes = Object.values(fileMap).map(v => `${v}.`).join('\n');
prologStatements += nodes + '\n\n';

// Separate and sort Prolog statements
let parentRelations = [];
let otherRelations = [];

uniqueTriples.forEach(t => {
    if (t.rel === 'parent') {
        parentRelations.push(`parent(${t.from}, ${t.to}).`);
    } else {
        otherRelations.push(`${t.rel}(${t.from}, ${t.to}).`);
    }
});

// Sort otherRelations alphabetically
otherRelations.sort();

// Concatenate Prolog statements: otherRelations and parentRelations 
prologStatements += otherRelations.join('\n') + '\n\n';
prologStatements += parentRelations.join('\n') + '\n\n';

// Output Prolog statements
dv.span(prologStatements, 'prolog');