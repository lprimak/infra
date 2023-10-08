#!/bin/zsh

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
nexus_version=$1
target_dir=${HOME}/apps/nexus/nexus-${nexus_version}

if [ -d $target_dir -o -f ${target_dir}.gz ]; then
    echo "$target_dir or ${target_dir}.gz already exists"
    exit 1
fi

wget https://download.sonatype.com/nexus/3/nexus-${nexus_version}-unix.tar.gz -q -O ${target_dir}.gz
if [ $? -ne 0 ]; then
    rm -f ${target_dir}.gz
    echo "Unable to download nexus"
    exit 1
fi

mkdir -p $target_dir
rm -rf $target_dir/../sonatype-work
gunzip -c ${target_dir}.gz | tar xf - -C $target_dir/..
rm -f ${target_dir}.gz

rm -rf $target_dir/../sonatype-work

sed -e 's+-Xms.*+-Xms500m+g' \
-e 's+-Xmx.*+-Xmx2703m+g' \
-e '/-Xms.*/i\
-XX:-MaxFDLimit' \
-e 's+../sonatype-work+${HOME}/var/sonatype-work+g' \
${target_dir}/bin/nexus.vmoptions > ${target_dir}/bin/nexus.vmoptions.2
mv ${target_dir}/bin/nexus.vmoptions.2 ${target_dir}/bin/nexus.vmoptions
