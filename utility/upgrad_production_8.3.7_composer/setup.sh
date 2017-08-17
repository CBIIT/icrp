#rm -rf icrp
git clone https://github.com/CBIIT/icrp.git

#setup links
ln -s icrp/utility/upgrade_production_8.3.7/create_icrp_8.2.7.sh 
ln -s icrp/utility/upgrade_production_8.3.7/upgrade_icrp_8.3.7.sh 
ln -s icrp/utility/upgrade_production_8.3.7/remove_layout_plugin.sh 
ln -s icrp/utility/upgrade_production_8.3.7/upgrade_modules.sh
mkdir $1 
cd $1
ln -s ../icrp/utility/upgrade_production_8.3.7/reset_layouts.sh
ln -s ../icrp/utility/upgrade_production_8.3.7/reset_layouts.sh
