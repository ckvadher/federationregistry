/*
 *  Nimble, an extensive application base for Grails
 *  Copyright (C) 2010 Bradley Beddoes
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
import grails.plugin.nimble.core.AdminsService
import grails.plugin.nimble.core.UserService

/**
 * Filter that works with Nimble security model to protect controllers, actions, views for Federation Registry
 *
 * @author Bradley Beddoes
 */
public class SecurityFilters extends grails.plugin.nimble.security.NimbleFilterBase {

    def filters = {

        // Federation registry content requiring users to be authenticated
        secure(controller: "attributeCompliance") {
            before = {
                accessControl (auth: false) {
					role(UserService.USER_ROLE)
				}
            }
			
        }

		// Administrative components
		administration(controller: "(admins|user|group|role)") {
            before = {
                accessControl {
                    role(AdminsService.ADMIN_ROLE)
                }
            }
        }

    }

}