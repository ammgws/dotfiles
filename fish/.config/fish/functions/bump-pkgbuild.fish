function bump-pkgbuild --description 'Update PKGBUILd to new version' --arguments new_version
	sed -E "s#(pkgver=).*#\1$new_version#" -i PKGBUILD

	updpkgsums
	makepkg --printsrcinfo > .SRCINFO
	
	git commit -v -a -m "Update to $new_version"
end
