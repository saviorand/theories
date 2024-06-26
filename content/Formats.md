Add dataviewjs at the top of the codeblock to enable

#### RDF

#### TTL

#### Prolog

```
function toPrologAtom(str) {
    return str.replace(/ /g, '_').toLowerCase(); // Replace spaces with underscores for Prolog atoms
}

const currentFolder = dv.current().file.folder;
const pages = dv.pages().filter(p => p.file && p.file.folder.startsWith(currentFolder));

let prologStatements = '';

const fileMap = {};
let triples = [];

// Populate the fileMap with all file paths and names in the current folder and subfolders
pages.forEach(page => {
    if (page.file && page.file.path) {
        const path = page.file.path;
        const fileName = toPrologAtom(page.file.name);
        fileMap[path] = fileName;
    }
});

// Generate the triples
pages.forEach(page => {
    if (!page.file || !page.file.path) return;
    const path = page.file.path;
    const fileName = toPrologAtom(page.file.name);
    const folderName = toPrologAtom(page.file.folder.split('/').pop());
    const outgoingLinks = page.file.outlinks ? [...new Set(page.file.outlinks.values.map(l => l.path))] : [];
    const processedLinks = {};

    const links = Object.entries(page).filter(([key, val]) => val && val.path != null).map(([key, val]) => {
        const item = { from: fileName, to: fileMap[val.path], rel: toPrologAtom(key) };
        processedLinks[val.path] = 1;
        return item;
    }).filter(item => item.from !== item.to); // Filter out self-referential links

    triples = triples.concat(links);
    const unnamedLinks = outgoingLinks.filter(l => !processedLinks[l]).map(l => ({ from: fileName, to: fileMap[l], rel: 'linked' }));
    triples = triples.concat(unnamedLinks);
});

// Remove duplicate triples
const uniqueTriples = Array.from(new Set(triples.map(JSON.stringify))).map(JSON.parse);

// Generate atoms for each node
const nodes = Object.values(fileMap).map(v => `${v}.`).join('\n');
prologStatements += nodes + '\n\n';

// Separate and sort Prolog statements for each edge
let parentRelations = [];
let linkedRelations = [];
let otherRelations = [];

uniqueTriples.forEach(t => {
    const fromPage = pages.find(page => fileMap[page.file.path] === t.from);
    const fromFolder = fromPage ? toPrologAtom(fromPage.file.folder.split('/').pop()) : '';
    const toPage = pages.find(page => fileMap[page.file.path] === t.to);
    const toFolder = toPage ? toPrologAtom(toPage.file.folder.split('/').slice(-2, -1)[0]) : '';

    if (fromFolder === toFolder) {
        parentRelations.push(`parent(${t.from}, ${t.to}).`);
    } else if (t.rel === 'linked') {
        linkedRelations.push(`${t.rel}(${t.from}, ${t.to}).`);
    } else {
        otherRelations.push(`${t.rel}(${t.from}, ${t.to}).`);
    }
});

// Sort otherRelations alphabetically
otherRelations.sort();

// Concatenate Prolog statements: otherRelations, parentRelations, and linkedRelations
prologStatements += otherRelations.join('\n') + '\n\n';
prologStatements += parentRelations.join('\n') + '\n\n';
prologStatements += linkedRelations.join('\n') + '\n\n';

// Output Prolog statements
dv.header(2, currentFolder);
dv.span(prologStatements, 'prolog');
```

