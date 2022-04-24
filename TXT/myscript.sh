#!/bin/bash
# Mon 07 Feb 2022 23:02:21 WIB

WEEK="07"
REC2="WhReen@localhost"
REC1="rms46@ui.ac.id"
FILES="my*.asc my*.txt my*.sh"
SHA="SHA256SUM"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
RESDIR="$HOME/SP_RESULT/"

[ -d $RESDIR ] || mkdir -p $RESDIR
pushd $RESDIR
for II in W?? ; do
    [ -d $II ] || continue
    TARFILE=my$II.tar.bz2
    TARFASC=$TARFILE.asc
    rm -vf $TARFILE $TARFASC
    echo "tar cfj $TARFILE $II/"
    tar cfj $TARFILE $II/
    echo "gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE"
    gpg --armor --output $TARFASC --encrypt --recipient $REC1 --recipient $REC2 $TARFILE
    #echo "Check and copy $TARFASC to $SCRIPT_DIR ..."
    #[ -f $TARFASC ] && cp -vf $TARFASC $SCRIPT_DIR #this line is from prev scripts
done
popd

if [[ "$WEEK" != "00" ]] ; then
   II="${RESDIR}myW$WEEK.tar.bz2.asc"
   echo "Check and move $II..."
   [ -f $II ] && mv -vf $II .
fi

echo "rm -f $SHA $SHA.asc"
rm -f $SHA $SHA.asc

echo "sha256sum $FILES > $SHA"
sha256sum $FILES > $SHA

echo "sha256sum -c $SHA"
sha256sum -c $SHA

echo "gpg --output $SHA.asc --armor --sign --detach-sign $SHA"
gpg --output $SHA.asc --armor --sign --detach-sign $SHA

echo "gpg --verify $SHA.asc $SHA"
gpg --verify $SHA.asc $SHA

echo ""
echo "==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ===="
echo "==== ==== ==== ATTN: is this WEEK $WEEK ?? ==== ==== ==== ===="
echo "==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ==== ===="
echo ""

exit 0
