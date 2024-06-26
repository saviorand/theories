---
title: What up
---
Social science yo

- [[Meta]]
- 

For ontology files put the following at the top of the file:
```
:- module(test1, [test1/0]).
:- reexport('folder/child').
:- include('theoryToolbox2').
```

For theories add the following::
```
:- use_module(library(scasp)).
```

From sCASP docs:
  | Op   | Description                                   |
  |------|-----------------------------------------------|
  | ?--  | Prove and only show the bindings              |
  | ?+-  | Prove, show bindings and model                |
  | ?-+  | Prove, show bindings and justification (tree) |
  | ?++  | Prove, show bindings model and justification) |
  | ??+- | As above, but using _human_ language output   |
  | ??-+ |						 |
  | ??++ |						 |


#### To-Do's
- [ ] Do I need an Obsidian plugin? Could be useful to automate
- [ ] How to use canvas view in this case? 
	- Should be easy because any item in canvas can be a md page
	- might need to add canvas labels manually to match named relations from dataview
		- [ ] can also make a script for that?
- [ ] Degree of standardization? Standard tags? Classes/hierarchies?
- [ ] need to improve logic in general and specifically code to represent hierarchies inside praxis 
	- see [chapter in Simply Logical book](https://book.simply-logical.space/src/text/2_part_ii/4.3.html)

#### Approach
1. Semantic layer/Ontology/Glossary/Dictionary
	- ontology in obsidian + dataviewjs + graph-link-types with labeled links or frontmatter
		- turn links into Prolog statements with a script [like so](https://github.com/Volland/pkg-obsidian/tree/main)
		- Make named links with link :: . (optional) use aliases for notes and tags for structure
		- optionally serialize for storage/exchange via RDF/turtle/any other format
	- hierarchy with folder note and waypoint (basically markdown links)
		- pick and node in the folder hierarchy as root
		- create a "Main" file in this node which will hold Prolog code
		- parent "Main" files can import children. There can be one big top-level root file (very useful for inference)
		- root file acts like a package manifest in software development. can include more stuff like links, relation definitions etc
			- [ ] Make a script that will automatically update parent root files to import children
		- can optionally do types and any kind of organization, tags, supertags etc
	- query this knowledge base with Prolog or whatever you want e.g. SparQL !
2. Logic/structure/inference layer
	- [ ] Try it
	- inference in prolog;  see [[Modes of Inference]]
		- express theories and logic/structures with prolog code (see theoryToolbox)
		- induction with FOLD
		- deduction and abduction with sCASP
3. Prediction/magic layer
	- Can pass the output to an LLM or other algorithms to answer questions or conduct search. Both to extend knowledge base and for inference
		- [ ] Try it
	- ... what else?

#### Advantages of this approach and goodies
- Can be easily stored in git, it's just markdown and prolog with one js script on top
- Can "enrich" with external ontologies e.g. DBPedia. 
	- Actually let's add an "externalDefinition" frontmatter item that will use any external link
- Can then import generated Prolog or generate code for Logtalk/Logica/other more advanced languages or compile to SQL
- Can optionally use [SparQL anything](https://github.com/SPARQL-Anything/sparql.anything) or similar to parse the whole contents of markdown pages as structured content, or use advanced frontmatter for more structure
- [ ] How to group terms with similar meanings
- Can visualize prolog logic
	- Visualise relationships, logical rules (AND, OR) and tables in Praxis
	- Just import the whole root code into Praxis 🤯