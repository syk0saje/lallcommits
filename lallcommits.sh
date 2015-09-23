# create a template dir for hooks (if you don't already have one)
mkdir -p ~/.git_template/hooks

# tell git to use this template dir (globally)
git config --global init.templatedir '~/.git_template'

# copy the post-commit hook from any existing lolcommits enabled repo
tmpdir=/tmp/lallcommits
mkdir $tmpdir
git -C $tmpdir init &> /dev/null
if [ $? -eq 0 ]; then
	
	(cd $tmpdir; lolcommits -e)
	cp $tmpdir/.git/hooks/post-commit ~/.git_template/hooks/

	# navigate to all existing local repos on your machine and run `git init`

	rootdir=${1:-$PWD}

	echo "enabling lolcommits for all git repos in $rootdir..."

	for gitdir in `find $rootdir -type d -name .git`; do
		dir=${gitdir%/.git}
		git -C $dir init &> /dev/null
		if [ $? -eq 0 ]; then
			echo "	[OK] $dir"
		else
			>&2 echo "	[FAIL] $dir"
		fi
	done

else
	>&2 echo "failed to initialize an empty git repo"
fi

rm -r $tmpdir
