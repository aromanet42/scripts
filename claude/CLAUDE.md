## Compound commands

Avoid chaining any commands with && or ;.                                                                                                                                                                                                                                                                
Each command must be its own Bash call.

BAD:
```
cd /home/audrey.romanet/workspace/tools-api-docs && git add <files>     
```

GOOD:
```
cd /home/audrey.romanet/workspace/tools-api-docs
```
then
```
git add <files>
```
