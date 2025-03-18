#!/bin/bash -p

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
nexus_version=$1
target_dir=${HOME}/apps/nexus/nexus-${nexus_version}

if [ ! -d ${HOME}/apps/nexus ]; then
    target_dir=$PWD/nexus-${nexus_version}
fi
tmp_dir=${target_dir}.tmp
nexus_tmp_dir=${tmp_dir}/nexus-${nexus_version}

if [ -d $tmp_dir ]; then
    rm -rf $tmp_dir
fi

if [ -d $target_dir ]; then
    echo "$target_dir already exists"
    exit 1
fi

mkdir -p ${nexus_tmp_dir}
wget https://download.sonatype.com/nexus/3/nexus-mac-aarch64-${nexus_version}.tar.gz -q \
-O ${nexus_tmp_dir}.gz

if [ $? -ne 0 ]; then
    rm -rf ${tmp_dir}
    rm -rf ${target_dir}
    echo "Unable to download nexus"
    exit 1
fi

gunzip -c ${nexus_tmp_dir}.gz | tar xf - -C $tmp_dir

sed -e 's+-Xms.*+-Xms500m+g' \
-e 's+-Xmx.*+-Xmx2703m+g' \
-e '/-Xms.*/i\
-XX:-MaxFDLimit' \
-e $(eval echo 's+../sonatype-work+${HOME}/var/sonatype-work+g') \
${nexus_tmp_dir}/bin/nexus.vmoptions > ${nexus_tmp_dir}/bin/nexus.vmoptions.2
mv ${nexus_tmp_dir}/bin/nexus.vmoptions.2 ${nexus_tmp_dir}/bin/nexus.vmoptions

mv ${nexus_tmp_dir} $target_dir
rm -rf ${tmp_dir}
