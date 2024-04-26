---
title: What up
---
Social science yo

- [[Knowledge]]
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


