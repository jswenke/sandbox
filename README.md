# sandbox

Repo desc.

Targets: 

* Nexys A7 (part no. XXXXX)

## Project building guide

### Build requirements 

* Vivado 2019.1
* These build instructions assume you have the git repo cloned to your local machine. If you need help with setting this up, take a look at the "Git help" section toward the bottom of this page.

### Building on Windows
1. Open the Vivado 2019.1 GUI
2. Tools > Run Tcl Script...
3. Navigate to script folder and select sandbox/scripts/make_project.tcl
4. Wait for project to build

### Building on Linux or Windows with Git Bash CMD
1. Assuming your current file location is inside the cloned repo, perform the following commands in git bash or linux console to build the project: 
```
# COMMENT (do not copy this line) :  on Windows, Xilinx folder path is likely /c/Xilinx/Vivado/2022.2
export XILINX_VIVADO=<YOUR_PATH_TO_XILINX_FOLDER_HERE>/Xilinx/Vivado/2022.2
./scripts/build.sh
```
2. Wait for project to build
3. Implementation may fail (still working on making build script generic)

## Editing

### Adding new sources

#### For design sources
For HDL you're writing, when creating the source specify the filepath of it to be in `sandbox/source/hdl_and_ip/XXXX`

In that filepath, either drop the source in by itself or make a folder of multiple sources such as `sandbox/source/hdl_and_ip/my_ip/your_group_of_design_sources/design1.vhd`, the build script should include these when ran.

#### For simulation sources
Same idea as adding design sources, except the filepath is `sandbox/source/simulation/testbenches`

Again, you may drop your files individually in there or make a folder within that filepath then add your sources.

#### For constraints
Update description here

## Acronyms

| Acronym | Description | 
| ------- | ----------- |
|  |   |
|  |   |

## Notes
### Daily
1/20/25: Make scripts dir and .tcl/.sh's for making/building project next

1/22/25: Update scripts to include synth/impl and contraints stuff, then add git guide or something

1/26/25: Start looking into tying UART together with async fifo, writing the fifo, etc.
Also look into adding a build ID functionality/register to keep track of builds when running/testing multiple

1/27/25: 
http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
Was reading this paper on async FIFO design, planning to follow some of the design recommendations and implement an async FIFO to test the UART RX/TX with

1/28/25:
Started barebones async fifo, wrote out some signals, types, etc. Read a bit more of the sunburst paper

1/29/25:
Read through gray code portions of sunburst paper. Some interesting considerations and I'd like to see what the benefit to doing this for clock domain crossings is. Did a lot of constraints writing at work today so brain is mush

2/2/25:
Included pic of gray code counters to be implemented for the FIFO wrptr and rdptr, started working on FIFO mem

2/6/25:
Wrote quick binary to gray converter and testbench for it to use in the FIFO modules, need to actually run the TB still

### Misc.


## Git help

### Q: What is a remote repository?

A: If you're reading this on the gitlab webpage, you are currently viewing the **remote repo**. The **remote repo** generally is the most up to date version that gitlab has of a given repo, and you must **add**, **commit**, and **push** changes from your **local repo** to update the **remote repo** with your changes. More on that later.

### Q: What is a local repository?

A: Before you can make changes to any of the files in the repository, you must first **clone** the project to your machine. **Cloning** to your machine creates a **local repo** for yourself. Think "local" means near you (on your machine), "remote" means far off (on the web; gitlab)

### Q: What does it mean to clone a repo?

A: As mentioned in the preivous answer, **cloning** just makes a copy on your machine of whatever files are in the remote repo. After you've cloned a repo, this version on your machine is referred to as the **local repo**. Typically, you will only need to do this <ins>one time</ins>, you will use other commands to update your remote/local repos in the future.

### Q: Cloning a repo, SSH or HTTPS?

A: Click the blue button in toward the top right of the webpage labeled **Code**. There will be a drop down showing two different options to copy to your clipboard before cloning the repo. You must choose whether you want to clone the repo using **SSH** or **HTTPS**. 

**SSH** makes your life easier but can be a little more complicated to set up. Once you do set it up however, you don't have to enter your access credentials everytime you do a git command that accesses the remote repo in some way.

Conversely, **HTTPS** is easier to set up but more of a hassle to work with, depending on the repo settings. In a more locked down repo, you will likely need to enter your username and access token whenever performing a git command that accesses the repo.

Take a look at this for more detailed instructions on how to set up your machine for SSH or HTTPS cloning:

https://docs.gitlab.com/ee/topics/git/clone.html


### Q: Before cloning, how do I set up a console environment to run git commands?

A: Now that you've set up your access token for HTTPS, or your key file for SSH, you should be able to clone the remote repo. 

If you're using Windows, I recommend installing **Git for Windows** (https://git-scm.com/downloads). Git for Windows let's you use a pseudo-linux console that makes using git console commands on Windows much easier, I think it also installs a GUI but we really care about the Git Bash console. 

Another option for Windows is using powershell, I don't have much experience using git in powershell so I'd recommend google and the gitlab docs for help on that. I do think that the git commands work identically to Git Bash or Linux console, but navigating file locations in powershell is a bit different.


### Q: How do I clone a repo?

A: In your console of choice, first navigate to the file location you'd like to place the folder that your repo will be in.

Run EITHER (not both) of the following commands but replace the link in each with the one in the dropdown after clicking the blue **Code** button on the repo webpage.

```
# FOR SSH:
git clone git@github.com:jswenke/sandbox.git 
# FOR HTTPS:
git clone https://github.com/jswenke/sandbox.git
```

**CHECK THE NEXT QUESTION BEFORE MAKING ANY CHANGES TO FILES**

### Q: Now that I've cloned a repo, what should I do before working on it?

A: After cloning a repo, you will be on the **default branch** of the repo. <ins>99% of the time, this is the main branch that we absolutely do not want to touch.</ins> 

So, you'll need to either **checkout** an existing branch or **create a new one**. Check the following questions for info on that.

### Q: What is a branch?

A: A branch is a different version of the branch that it was branched from. To make sense of that, remember that after cloning a repo, we're put on the **default branch**. Think of the default branch as a tree trunk. If you wanted the tree to remain standing, you wouldn't hack away directly at the trunk. So, when we make a **new branch**, it inherits all the characteristics and files from the **default branch** and you are able to chop away at your new branch without affecting the one it was branched from. Also, you can make a new branch from whatever other branch, it does not have to be the main or default branch.

### Q: How do I make a new branch?

A: First, check what branch you're on with:
``` 
git status
```
If you're not on the branch you want to branch from, do:
```
# comment : do not include the <>'s
git checkout <branch_you_want>
```
Next, we'll make a new branch with that is a copy of **branch_you_want** with:
```
git branch <name_of_new_branch>
```
Then, switch to your new branch with:
```
git checkout <name_of_new_branch>
```
Now, you'll need to push your new branch from your **local repo** to the **remote repo**:
```
git push -u origin <name_of_new_branch>
```
From here, you're able to work freely on your new branch

### Q: How do I switch branches correctly?

A: Say you are on a branch named **your_branch**, and a peer has linked you their branch in the same repo called **testing_branch**. They want you to make some edits on their branch and you first need to switch to it like so:

**Switching branches**
```
git checkout testing_branch

# checks for updates to current branch
git fetch

# pulls down newest updates from their remote branch to their branch you just switched to locally
git pull
```
From there, you're free to alter things however you'd like but note that any changes you push from here will affect your peer's remote branch. If you push something accidentally it's not a big deal, you can just revert to a previous commit.

### Q: How do I add/remove files from gitlab/the remote repo?

A: Anytime you modify or create a file, you must add, commit, and push for the changes in your local repo to be reflected in the remote repo.

**Adding and removing/deleting files to a commit**
```
# to see list of modified files (files that have been locally changed but still need to be added or removed)
git status

# add files you want to update in remote repo
# if the file is in your current console location:
git add <file1>
# if the file is located elsewhere:
git add <path/to/your/file2>

# adds all files from folder1
git add <folder1/*>

# adds all files ending in .vhd from folder2
git add <folder2/*.vhd>

# remove a file from the remote repo
# note: must also delete the file locally if you want it deleted in your local repo/folder
git rm <file3>

# remove all the contents of a folder, but not the folder itself
git rm <folder3/*>

# recursively delete/remove a folder and all of its contents
git rm -r <folder4/*>

# git status again, all your changes should be green
git status
```

Next, we want to **commit** our changes

**Making a commit with files you just added or removed**
```
git commit -m "message describing changes being pushed with your commit"
```

Finally, we need to **push** our changes to the remote repo

**Pushing a commit**
```
git push
```
Note: you may need to enter your username and access token again here if you cloned with HTTPS


Your changes should now be reflected as a new commit on gitlab/the remote branch

### Q: Git Bash/Powershell/Linux console Tips?
Note: I think most of these also work in powershell, but they all work for Git Bash and Linux console 

#### Tab to autocomplete
This is extremely useful for typing out filepaths when adding or removing file
#### Ctrl+r to search command history
Press ctrl+r then start typing a command, press ctrl+r to cycle commands brought up in the search, then press enter to run that command
#### Ctrl+c to clear your current line or cancel a running process
#### Arrow up for previous command
#### Middle mouse click to paste to console


