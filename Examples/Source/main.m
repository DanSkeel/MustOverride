//
//  main.m
//  MustOverride
//
//  Created by Nick Lockwood on 22/02/2015.
//  Copyright (c) 2015 Nick Lockwood. All rights reserved.
//

@import Foundation;
#import "MustOverride.h"


@interface AbstractBaseClass : NSObject

- (void)optionalOverride;
- (void)mustOverride;
- (void)mustOverrideOnlyNearestSubclass;
- (void)subclassWillAlsoAskToOverride;

@end

@implementation AbstractBaseClass

- (void)optionalOverride
{  
    NSLog(@"Optional");
}

- (void)mustOverride
{
    SUBCLASS_MUST_OVERRIDE;

    NSLog(@"Must");
}

- (void)mustOverrideOnlyNearestSubclass
{
    SUBCLASS_MUST_OVERRIDE;
    
    NSLog(@"Must OnlyNearestSubclass");
}

- (void)subclassWillAlsoAskToOverride
{
    SUBCLASS_MUST_OVERRIDE;
    
    NSLog(@"subclassWillAlsoAskToOverride");
}


@end

@implementation AbstractBaseClass (ExtraMethods)

- (void)alsoMustOverride
{
  SUBCLASS_MUST_OVERRIDE;

  NSLog(@"Also Must");
}

@end


@interface ConcreteSubclass : AbstractBaseClass

@end

@implementation ConcreteSubclass

// Doesn't override `mustOverride`, `alsoMustOverride`
// And will crash as a result.

- (void)mustOverrideOnlyNearestSubclass {
    NSLog(@"%@ implementatoin of %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)subclassWillAlsoAskToOverride {
    SUBCLASS_MUST_OVERRIDE;
    NSLog(@"%@ implementatoin of %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end

@interface SubclassOfConcreteSubclass : ConcreteSubclass
@end

@implementation SubclassOfConcreteSubclass

// Will NOT crash on `mustOverrideOnlyNearestSubclass`
// because super class overrides it

// Will crash on `subclassWillAlsoAskToOverride`
// because super class also asked to override it

@end


int main(__unused int argc, __unused const char * argv[])
{
    @autoreleasepool
    {
        AbstractBaseClass *foo = [[AbstractBaseClass alloc] init];
        [foo optionalOverride];
        [foo mustOverride];

        AbstractBaseClass *bar = [[ConcreteSubclass alloc] init];
        [bar optionalOverride];
        [bar mustOverride];
    }
    return 0;
}
