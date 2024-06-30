%% Begin Waypoint %%


%% End Waypoint %%

```dataviewjs
function toPrologAtom(str) {
    return str.replace(/ /g, '_').toLowerCase(); // Replace spaces with underscores for Prolog atoms
}

const currentFolder = dv.current().file.folder;
const pages = dv.pages().filter(p => p.file && p.file.folder.startsWith(currentFolder));

let prologStatements = '';

const fileMap = {};
const fileMapAll = {};
let triples = [];

// Populate the fileMap for current folder and fileMapAll for the whole Vault
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

// Generate the triples
pages.forEach(page => {
    if (!page.file || !page.file.path) return;
    const path = page.file.path;
    const fileName = toPrologAtom(page.file.name);
    const folderName = toPrologAtom(page.file.folder.split('/').pop());
    const outgoingLinks = page.file.outlinks ? [...new Set(page.file.outlinks.values.map(l => l.path))] : [];
    const processedLinks = {};

    const links = Object.entries(page).filter(([key, val]) => val && val.path != null).map(([key, val]) => {
        const item = { from: fileName, to: fileMapAll[val.path], rel: toPrologAtom(key) };
        processedLinks[val.path] = 1;
        return item;
    }).filter(item => item.from !== item.to); // Filter out self-referential links

    triples = triples.concat(links);
    const unnamedLinks = outgoingLinks.filter(l => !processedLinks[l]).map(l => ({ from: fileName, to: fileMapAll[l], rel: 'linked' }));
    triples = triples.concat(unnamedLinks);
});

// Remove duplicate triples
const uniqueTriples = Array.from(new Set(triples.map(JSON.stringify))).map(JSON.parse);

// Generate atoms for each node
const nodes = Object.values(fileMap).map(v => `${v}.`).join('\n');
prologStatements += nodes + '\n\n';

// Separate and sort Prolog statements for each edge
let parentRelations = [];
let otherRelations = [];

uniqueTriples.forEach(t => {
    const fromPage = pages.find(page => fileMap[page.file.path] === t.from);
    const toPage = dv.pages().find(page => fileMapAll[page.file.path] === t.to);

    // Check if 'toPage' is in the same folder as 'fromPage' OR if 'toPage' is in a subfolder of 'fromPage'
    if (toPage && (
        toPage.file.folder === fromPage.file.folder || 
        toPage.file.folder.startsWith(fromPage.file.folder + '/')
    )) {
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
dv.header(2, currentFolder);
dv.span(prologStatements, 'prolog');
```