﻿component{

	property name="userService" inject="entityService:User";
	property name="roleService" inject="entityService:Role";
	property name="permissionService" inject="entityService:Permission";

	function index( event, rc, prc ){
		param rc.ignoreDefaults = false;
		param rc.includes = "";
		param rc.excludes = "";

		var mockData = {
			fname = "testuser",
			lname = "testuser",
			email = "testuser@testuser.com",
			username = "testuser",
			isConfirmed = true,
			isActive = true,
			otherURL = "www.luismajano.com"
		};

		var oUser = populateModel(
			model					= userService.new(),
			memento 				= mockData,
			composeRelationships	= true
		);
		oUser.setRole(
			roleService.new( {
				role="Admin",
				description="Awesome Admin"
			} )
		);
		oUser.getRole().setPermissions( [
			permissionService.new( { permission="READ", description="read" } ),
			permissionService.new( { permission="WRITE", description="write" } )
		] );
		oUser.setPermissions( [
			permissionService.new( { permission="CUSTOM_READ", description="read" } ),
			permissionService.new( { permission="CUSTOM_WRITE", description="write" } )
		] );

		return oUser.getMemento(
			includes        = rc.includes,
			excludes        = rc.excludes,
			ignoreDefaults 	= rc.ignoreDefaults,
			mappers = {
				lname = function( item ){ return item.ucase(); }
			}
		);
	}

	function resultMap( event, rc, prc ){
		// mock 10 users
		var aObjects = getInstance( "MockData@mockdatacfc" )
			.mock(
				userID = "uuid",
				fname = "fname",
				lname = "lname",
				email = "email",
				username = "words",
				isConfirmed = "oneof:true:false",
				isActive = "oneof:true:false",
				otherURL = "words"
			)
			// Build out objects
			.map( function( item ){
				return populateModel(
					model					= userService.new(),
					memento 				= item,
					composeRelationships	= true
				);
			} );

		return getInstance( "ResultsMapper@mementifier" )
			.process( aObjects, "userId" );
	}

	function alreadySerialized( event, rc, prc ){
		param rc.ignoreDefaults = false;
		param rc.includes = "";
		param rc.excludes = "";

		var mockData = {
			fname = "testuser",
			lname = "testuser",
			email = "testuser@testuser.com",
			username = "testuser",
			isConfirmed = true,
			isActive = true,
			otherURL = "www.luismajano.com",
			alreadySerialized = [
				{
					'foo'	= 'bar'
				},
				{
					'baz'	= 'frobozz'
				}
			]
		};

		var oUser = populateModel(
			model					= userService.new(),
			memento 				= mockData,
			composeRelationships	= true
		);

		return oUser.getMemento(
			includes        = rc.includes,
			excludes        = rc.excludes,
			ignoreDefaults 	= rc.ignoreDefaults,
			mappers = {}
		);
	}

}