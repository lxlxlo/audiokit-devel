#include "plumber.h"

int sporth_delay(sporth_stack *stack, void *ud)
{
    plumber_data *pd = ud;
    SPFLOAT input;
    SPFLOAT out;
    SPFLOAT time;
    SPFLOAT feedback;
    sp_delay *delay;

    switch(pd->mode) {
        case PLUMBER_CREATE:

#ifdef DEBUG_MODE
            fprintf(stderr, "delay: Creating\n");
#endif

            sp_delay_create(&delay);
            plumber_add_ugen(pd, SPORTH_DELAY, delay);
            if(sporth_check_args(stack, "fff") != SPORTH_OK) {
                fprintf(stderr,"Not enough arguments for delay\n");
                stack->error++;
                return PLUMBER_NOTOK;
            }
            time = sporth_stack_pop_float(stack);
            feedback = sporth_stack_pop_float(stack);
            input = sporth_stack_pop_float(stack);
            sporth_stack_push_float(stack, 0);
            break;
        case PLUMBER_INIT:

#ifdef DEBUG_MODE
            fprintf(stderr, "delay: Initialising\n");
#endif

            time = sporth_stack_pop_float(stack);
            feedback = sporth_stack_pop_float(stack);
            input = sporth_stack_pop_float(stack);
            delay = pd->last->ud;
            sp_delay_init(pd->sp, delay, time);
            sporth_stack_push_float(stack, 0);
            break;
        case PLUMBER_COMPUTE:
            time = sporth_stack_pop_float(stack);
            feedback = sporth_stack_pop_float(stack);
            input = sporth_stack_pop_float(stack);
            delay = pd->last->ud;
            delay->feedback = feedback;
            sp_delay_compute(pd->sp, delay, &input, &out);
            sporth_stack_push_float(stack, out);
            break;
        case PLUMBER_DESTROY:
            delay = pd->last->ud;
            sp_delay_destroy(&delay);
            break;
        default:
            fprintf(stderr, "delay: Uknown mode!\n");
            break;
    }
    return PLUMBER_OK;
}
